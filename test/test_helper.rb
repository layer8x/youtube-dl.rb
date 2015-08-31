if RUBY_PLATFORM == "java"
  require 'simplecov'
  SimpleCov.start
else
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'purdytest' # minitest-colorize is broken in minitest version 5
require 'pry'
require 'fileutils'

require 'youtube-dl'

TEST_URL = "https://www.youtube.com/watch?feature=endscreen&v=gvdf5n-zI14"
TEST_URL2 = "https://www.youtube.com/watch?v=Mt0PUjh-nDM"
TEST_FILENAME = "nope.avi.mp4"
TEST_FORMAT = "5"
TEST_GLOB = "nope*"

def remove_downloaded_files
  Dir.glob("**/nope*").each do |nope|
    File.delete(nope)
  end
end
