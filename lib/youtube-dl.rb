require 'terrapin'
require 'json'
require 'ostruct'

require 'youtube-dl/version'
require 'youtube-dl/support'
require 'youtube-dl/options'
require 'youtube-dl/runner'
require 'youtube-dl/video'

# Global YoutubeDL module. Contains some convenience methods and all of the business classes.
module YoutubeDL
  extend self
  extend Support

  # Downloads given array of URLs with any options passed
  #
  # @param urls [String, Array] URLs to download
  # @param options [Hash] Downloader options
  # @return [YoutubeDL::Video, Array] Video model or array of Video models
  def download(urls, options = {})
    if urls.is_a? Array
      urls.map { |url| YoutubeDL::Video.get(url, options) }
    else
      YoutubeDL::Video.get(urls, options) # Urls should be singular but oh well. url = urls. There. Go cry in a corner.
    end
  end

  alias_method :get, :download

  # Lists extractors
  #
  # @return [Array] list of extractors
  def extractors
    @extractors ||= terrapin_line('--list-extractors').run.split("\n")
  end

  # Returns youtube-dl's version
  #
  # @return [String] youtube-dl version
  def binary_version
    @binary_version ||= terrapin_line('--version').run.strip
  end

  # Returns user agent
  #
  # @return [String] user agent
  def user_agent
    @user_agent ||= terrapin_line('--dump-user-agent').run.strip
  end
end
