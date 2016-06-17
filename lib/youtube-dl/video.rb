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
      @options = YoutubeDL::Options.new(options.merge(default_options))
      @options.banned_keys = banned_keys
    end

    # Download the video.
    def download
      raise ArgumentError.new('url cannot be nil') if @url.nil?
      raise ArgumentError.new('url cannot be empty') if @url.empty?

      set_information_from_json(YoutubeDL::Runner.new(url, runner_options).run)
    end

    alias_method :get, :download

    # Returns the expected filename
    #
    # @return [String] Filename downloaded to
    def filename
      self._filename
    end

    # Metadata information for the video, gotten from --print-json
    #
    # @return [OpenStruct] information
    def information
      @information || grab_information_without_download
    end

    # Redirect methods for information getting
    #
    # @param method [Symbol] method name
    # @param args [Array] method arguments
    # @param block [Proc] explict block
    # @return [Object] The value from @information
    def method_missing(method, *args, &block)
      value = information[method]

      if value.nil?
        super
      else
        value
      end
    end

  private

    # Add in other default options here.
    def default_options
      {
        color: false,
        progress: false,
        print_json: true
      }
    end

    def banned_keys
      [
        :get_url,
        :get_title,
        :get_id,
        :get_thumbnail,
        :get_description,
        :get_duration,
        :get_filename,
        :get_format
      ]
    end

    def runner_options
      YoutubeDL::Options.new(@options.to_h.merge(default_options))
    end

    def set_information_from_json(json) # :nodoc:
      @information = JSON.parse(json, symbolize_names: true)
    end

    def grab_information_without_download # :nodoc:
      set_information_from_json(YoutubeDL::Runner.new(url, runner_options.with({skip_download: true})).run)
    end
  end
end
