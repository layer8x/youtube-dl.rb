module YoutubeDL
  # Video model for using and downloading a single video.
  class Video < Runner
    class << self
      # Instantiate a new Video model and download the video
      #
      #   YoutubeDL.download 'https://www.youtube.com/watch?v=KLRDLIIl8bA' # => #<YoutubeDL::Video:0x00000000000000>
      #   YoutubeDL.get 'https://www.youtube.com/watch?v=ia1diPnNBgU', extract_audio: true, audio_quality: 0
      #
      # @param url [String] URL to use and download
      # @param options [Hash] Options to pass in
      # @return [YoutubeDL::Video] new Video model
      def download(url, options = {})
        video = new(url, options)
        video.download
        video
      end
      alias_method :get, :download
    end

    # @return [YoutubeDL::Options] Download Options for the last download
    attr_reader :download_options

    # Instantiate new model
    #
    # @param url [String] URL to initialize with
    # @param options [Hash] Options to populate the everything with
    def initialize(url, options = {})
      @url = url
      @options = YoutubeDL::Options.new(options)
    end

    # Download the video.
    def download
      raise ArgumentError.new('url cannot be nil') if @url.nil?
      raise ArgumentError.new('url cannot be empty') if @url.empty?

      @download_options = YoutubeDL::Options.new(runner_options)
      set_information_from_json(YoutubeDL::Runner.new(url, @download_options).run)
    end

    alias_method :get, :download

    # Parses the last downloaded output for a filename and returns it.
    #
    # @return [String] Filename downloaded to
    def filename
      @information._filename
    end

    def information
      @information || grab_information_without_download
    end

    def method_missing(method, *args, &block)
      value = information.send(method, *args, &block)
      
      if value.nil?
        super
      else
        value
      end
    end

  private

    # Add in other default options here.
    def runner_options
      {
        color: false,
        progress: false,
        print_json: true
      }.merge(@options)
    end

    def set_information_from_json(json)
      @information = OpenStruct.new(JSON.parse(json))
    end

    def grab_information_without_download
      set_information_from_json(YoutubeDL::Runner.new(url, runner_options.merge({skip_download: true})).run)
    end
  end
end
