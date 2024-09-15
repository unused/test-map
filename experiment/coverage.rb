# frozen_string_literal: true

require 'coverage'

Coverage.start

require_relative './all'

hello_a
hello_c

puts "Files: #{Coverage.result.keys}"
