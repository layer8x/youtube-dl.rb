module YoutubeDL
  # Video model
  class Video
    class << self
      def download(url, options={})
        video = new(options.merge(url: url))
      end

      alias_method :get, :download
    end

    def initialize(options={})
      @url = options[:url]
    end

    def download
      YoutubeDL::Runner.new(url, runner_options).run
    end

  private
    def runner_options
      {
        get_filename: true
      }
    end
  end
end
