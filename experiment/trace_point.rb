# frozen_string_literal: true

require_relative './all'

files = []

trace = TracePoint.new(:call) do |tp|
  files << tp.path
end

trace.enable do
  hello_a
  hello_c
end

puts files
