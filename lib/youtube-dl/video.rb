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
      @last_download_output = YoutubeDL::Runner.new(url, @download_options).run
    end

    alias_method :get, :download

    # Parses the last downloaded output for a filename and returns it.
    #
    # @return [String] Filename downloaded to
    def filename
      @filename ||= YoutubeDL::Output.new(@last_download_output).filename
    end

    # attr_reader for metadata
    #
    # @return [Hash] metadata information
    def information
      @information || get_information
    end

    # Method missing for pulling metadata from @information
    #
    # @param method [Symbol] method name
    # @param args [Array] list of arguments passed
    # @param block [Proc] implicit block given
    # @return [Object] the value of method in the metadata store
    def method_missing(method, *args, &block)
      if information.has_key? method
        information.fetch(method)
      else
        super
      end
    end

  private

    # Add in other default options here.
    def runner_options
      {
        color: false,
        progress: false
      }.merge(@options)
    end

    # Get information about the video
    def get_information
      # Not using symbolize_names since we have some special keys.
      raw_information = JSON.parse(cocaine_line("--print-json #{quoted(url)}").run)

      @information = symbolize_json(raw_information).each_key do |key|
        self.class.send(:define_method, key) do
          information.fetch(key)
        end
      end
    end
  end
end
