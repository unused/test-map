# frozen_string_literal: true

require './test/test_helper'
require 'tmpdir'
require 'fileutils'

# Tests for cache class.
class CacheTest < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    @cache_file = File.join(@tmpdir, '.test-cache.yml')
    @map_file = File.join(@tmpdir, '.test-map.yml')

    # Create source and test files in tmpdir
    @source_file = create_file('lib/foo.rb', 'class Foo; end')
    @test_file = create_file('test/foo_test.rb', 'class FooTest; end')

    # Write a map file: source -> [test]
    @map = { 'lib/foo.rb' => ['test/foo_test.rb'] }
    File.write(@map_file, @map.to_yaml)
  end

  def teardown = FileUtils.rm_rf(@tmpdir)

  def test_fresh_returns_false_when_no_cache
    refute subject.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_true_when_all_match
    write_cache_for_current_state

    assert subject.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_false_when_source_changed
    write_cache_for_current_state
    File.write(@source_file, 'class Foo; def bar; end; end')

    refute new_cache.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_false_when_test_file_changed
    write_cache_for_current_state
    File.write(@test_file, 'class FooTest; def test_bar; end; end')

    refute new_cache.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_false_when_gemfile_lock_changed
    create_file('Gemfile.lock', 'GEM remote: https://rubygems.org')
    write_cache_for_current_state
    File.write(File.join(@tmpdir, 'Gemfile.lock'), 'GEM remote: https://rubygems.org UPDATED')

    refute new_cache.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_false_when_ruby_version_changed
    create_file('.ruby-version', '3.2.2')
    write_cache_for_current_state
    File.write(File.join(@tmpdir, '.ruby-version'), '3.3.0')

    refute new_cache.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_false_when_file_missing_from_cache
    File.write(@cache_file, {}.to_yaml)

    refute subject.fresh?('test/foo_test.rb')
  end

  def test_fresh_returns_false_when_test_not_in_map
    write_cache_for_current_state

    refute subject.fresh?('test/unknown_test.rb')
  end

  def test_write_creates_cache_file
    subject.write(@map)

    assert_path_exists @cache_file
    cache = YAML.safe_load_file(@cache_file)

    assert_equal Digest::SHA256.file(@source_file).hexdigest, cache['lib/foo.rb']
    assert_equal Digest::SHA256.file(@test_file).hexdigest, cache['test/foo_test.rb']
  end

  def test_write_includes_global_files
    gemfile_lock = create_file('Gemfile.lock', 'GEM')
    create_file('.ruby-version', '3.2.2')

    subject.write(@map)

    cache = YAML.safe_load_file(@cache_file)

    assert_includes cache.keys, 'Gemfile.lock'
    assert_includes cache.keys, '.ruby-version'
    assert_equal Digest::SHA256.file(gemfile_lock).hexdigest, cache['Gemfile.lock']
  end

  def test_write_skips_nonexistent_global_files
    subject.write(@map)

    cache = YAML.safe_load_file(@cache_file)

    refute_includes cache.keys, 'Gemfile.lock'
    refute_includes cache.keys, '.ruby-version'
  end

  def test_write_produces_sorted_keys
    create_file('lib/bar.rb', 'class Bar; end')
    create_file('test/bar_test.rb', 'class BarTest; end')

    results = {
      'lib/foo.rb' => ['test/foo_test.rb'],
      'lib/bar.rb' => ['test/bar_test.rb']
    }
    File.write(@map_file, results.to_yaml)
    subject.write(results)
    cache = YAML.safe_load_file(@cache_file)

    assert_equal cache.keys, cache.keys.sort
  end

  private

  def subject = @subject ||= new_cache
  def new_cache = TestMap::Cache.new(@cache_file, @map_file, root: @tmpdir)

  def create_file(relative_path, content)
    File.join(@tmpdir, relative_path).tap do |full_path|
      FileUtils.mkdir_p(File.dirname(full_path))
      File.write(full_path, content)
    end
  end

  def write_cache_for_current_state = subject.write(@map)
end
