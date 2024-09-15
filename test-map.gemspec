# frozen_string_literal: true

require_relative 'lib/test_map/version'

Gem::Specification.new do |spec|
  spec.name = 'test-map'
  spec.version = TestMap::VERSION
  spec.authors = ['Christoph Lipautz']
  spec.email = ['christoph@lipautz.org']

  spec.summary = 'Track associated files of tests.'
  spec.description = <<~MSG
    Track files that are covered by test files to execute only the necessary
    tests.
  MSG
  spec.homepage = 'https://github.com/unused/test-map'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/main/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released. The
  # `git ls-files -z` loads the files in the RubyGem that have been added into
  # git.
  spec.files = Dir['LICENSE.txt', 'CHANGELOG.md', 'README.md', 'lib/**/*']
  spec.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']
end
