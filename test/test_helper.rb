if RUBY_PLATFORM == "java"
  require 'simplecov'
  SimpleCov.start
else
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end
gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'purdytest' # minitest-colorize is broken in minitest version 5
require 'pry'

require_relative '../lib/youtube-dl.rb'

NOPE = "https://www.youtube.com/watch?v=gvdf5n-zI14"
YOUTUBE_DL_FORMAT_FLV = "5"

def remove_downloaded_files
  Dir.glob("**/nope*").each do |nope|
    File.delete(nope)
  end
end
