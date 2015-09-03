module YoutubeDL
  # Video model
  class Video
    class << self
      def download(url, options={})
        YoutubeDL::Runner.new(url, YoutubeDL::Options.new(options)).run
      end
      
      alias_method :get, :download
    end
  end
end
