require 'youtube-dl/version'
require 'youtube-dl/support'
require 'youtube-dl/options'
require 'youtube-dl/runner'
require 'youtube-dl/video'

module YoutubeDL
  extend self
  extend Support

  # Downloads given array of URLs with any options passed
  #
  # @param urls [String, Array] URLs to download
  # @param options [Hash] Downloader options
  def download(urls, options={})
    # force convert urls to array
    urls = [urls] unless urls.is_a? Array

    urls.each do |url|
      YoutubeDL::Video.get(url, options)
    end
  end

  alias_method :get, :download

  def extractors
    @extractors ||= _cocaine_youtube_dl('--list-extractors').split("\n")
  end

  def binary_version
    @binary_version ||= _cocaine_youtube_dl('--version').strip
  end

  def user_agent
    @user_agent ||= _cocaine_youtube_dl('--dump-user-agent').strip
  end

  # Helper for doing information stuff
  def _cocaine_youtube_dl(*query)
    Cocaine::CommandLine.new(usable_executable_path_for('youtube-dl'), *query).run
  end
end
