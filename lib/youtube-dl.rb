require 'youtube-dl/version'
require 'youtube-dl/support'
require 'youtube-dl/options'
require 'youtube-dl/runner'

module YoutubeDL
  extend self

  # Downloads given array of URLs with any options passed
  #
  # @param urls [String, Array] URLs to download
  # @param options [Hash] Downloader options
  def download(urls, options={})
    # force convert urls to array
    urls = [urls] unless urls.is_a? Array

    urls.each do |url|
      runner = YoutubeDL::Runner.new(url, YoutubeDL::Options.new(options))
      runner.run
    end
  end

  alias_method :get, :download
end
