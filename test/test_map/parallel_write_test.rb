# frozen_string_literal: true

require './test/test_helper'
require 'fileutils'
require 'yaml'

class ParallelWriteTest < Minitest::Test
  def setup
    @out_file = File.expand_path('test-map-parallel.yml')
    @cache_file = File.expand_path('test-cache-parallel.yml')
    FileUtils.rm_f(@out_file)
    FileUtils.rm_f(@cache_file)
    TestMap.reporter.clear

    TestMap::Config.configure do |config|
      config[:merge] = true
      config[:out_file] = 'test-map-parallel.yml'
      config[:cache_file] = 'test-cache-parallel.yml'
    end
  end

  def teardown
    FileUtils.rm_f(@out_file)
    FileUtils.rm_f(@cache_file)
    Dir.glob('test_*.rb').each { |f| FileUtils.rm_f(f) }
    Dir.glob('source_*.rb').each { |f| FileUtils.rm_f(f) }
  end

  def test_parallel_writes_merge_correctly
    skip 'Forking is not supported on this platform' unless Process.respond_to?(:fork)

    worker_count = 8
    run_parallel_workers(worker_count)

    verify_parallel_results(worker_count)
  end

  private

  def run_parallel_workers(count)
    TestMap.suite_passed = true
    pids = count.times.map do |i|
      fork { run_worker_task(i) }
    end
    pids.each { |pid| Process.wait(pid) }
  end

  def run_worker_task(index)
    File.write("test_#{index}.rb", "# test #{index}")
    File.write("source_#{index}.rb", "# source #{index}")
    TestMap.reporter.add(["test_#{index}.rb", "source_#{index}.rb"])
    results = TestMap.reporter.write(@out_file)
    TestMap::Cache.new(@cache_file, @out_file).write(results)
  end

  def verify_parallel_results(count)
    assert_path_exists @out_file, 'Map file should exist'
    assert_path_exists @cache_file, 'Cache file should exist'

    final_map = YAML.safe_load_file(@out_file)

    assert_equal count, final_map.size, "Should have results from all #{count} workers"

    count.times do |i|
      assert_includes final_map["source_#{i}.rb"], "test_#{i}.rb"
    end
  end
end
