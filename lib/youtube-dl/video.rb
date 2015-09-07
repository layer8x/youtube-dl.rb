module YoutubeDL
  # Video model
  class Video
    class << self
      # Instantiate a new Video model and download the video
      #
      # @param url [String] URL to use and download
      # @param options [Hash] Options to pass in
      # @return [YoutubeDL::Video] new Video model
      def download(url, options={})
        video = new(url, options)
        video.download
        video
      end

      alias_method :get, :download
    end

    # [YoutubeDL::Options] Options access.
    attr_reader :options

    # [String] URL to download
    attr_reader :url

    # Instantiate new model
    #
    # @param options [Hash] Options to populate the everything with
    def initialize(url, options={})
      @url = url
      @options = YoutubeDL::Options.new(options)
    end

    # Download the video.
    def download
      YoutubeDL::Runner.new(url, runner_options).run
    end

  private
    # Add in other default options here.
    def runner_options
      {
        no_color: true
      }.merge(@options)
    end
  end
end
