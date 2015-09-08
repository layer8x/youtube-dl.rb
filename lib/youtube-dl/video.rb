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
      def download(url, options={})
        video = new(url, options)
        video.download
        video
      end

      alias_method :get, :download
    end

    # [YoutubeDL::Options] Download Options for the last download
    attr_reader :download_options

    # Instantiate new model
    #
    # @param url [String] URL to initialize with
    # @param options [Hash] Options to populate the everything with
    def initialize(url, options={})
      @url = url
      @options = YoutubeDL::Options.new(options)
    end

    # Download the video.
    def download
      @download_options = YoutubeDL::Options.new(runner_options)
      @last_download_output = YoutubeDL::Runner.new(url, @download_options).run
    end

    alias_method :get, :download

    # Returns a list of supported formats for the video in the form of
    # [{:format_code => '000', :extension => 'avi', :resolution => '320x240', :note => 'More details about the format'}]
    #
    # @return [Array] Format list
    def formats
      @formats ||= YoutubeDL::Output.new(cocaine_line("--list-formats #{quoted(url)}").run).supported_formats
    end

    # @return [String] Filename downloaded to
    def filename
      @filename ||= YoutubeDL::Output.new(@last_download_output).filename
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
