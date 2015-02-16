require 'youtube-dl/version'
require 'youtube-dl/options'
require 'youtube-dl/runner'

module YoutubeDL
  extend self
  def download(urls, options={})

    urls = [urls] unless urls.is_a? Array

    urls.each do |url|
      runner = YoutubeDL::Runner.new(url, YoutubeDL::Options.new(options))
      runner.run
    end
  end

  alias_method :get, :download
end
