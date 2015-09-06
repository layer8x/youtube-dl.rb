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
    @extractors ||= Cocaine::CommandLine.new(usable_executable_path_for('youtube-dl'), '--list-extractors').run.split("\n")
  end

  def binary_version
    @binary_version ||= Cocaine::CommandLine.new(usable_executable_path_for('youtube-dl'), '--version').run.chomp
  end
end
