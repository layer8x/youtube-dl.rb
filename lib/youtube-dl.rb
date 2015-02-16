require 'youtube-dl/version'
require 'youtube-dl/options'
require 'youtube-dl/runner'

module YoutubeDL
  extend self
  def download(url, options={})
    runner = YoutubeDL::Runner.new(url, YoutubeDL::Options.new(options))
    runner.run
  end

  alias_method :get, :download
end
