module YoutubeDL
  # Utility class for running and managing youtube-dl
  class Runner
    include YoutubeDL::Support

    # @return [String] URL to download
    attr_accessor :url

    # @return [YoutubeDL::Options] Options access.
    attr_accessor :options

    # @return [String] Executable path
    attr_reader :executable_path

    # @return [String] Executable name to use
    attr_accessor :executable

    # Command Line runner initializer
    #
    # @param url [String] URL to pass to youtube-dl executable
    # @param options [Hash, Options] options to pass to the executable. Automatically converted to Options if it isn't already
    def initialize(url, options = {})
      @url = url
      @options = YoutubeDL::Options.new(options)
      @executable = 'youtube-dl'
    end

    # Returns usable executable path for youtube-dl
    #
    # @return [String] usable executable path for youtube-dl
    def executable_path
      @executable_path ||= usable_executable_path_for(@executable)
    end

    # Returns Terrapin's runner engine
    #
    # @return [CommandLineRunner] backend runner class
    def backend_runner
      Terrapin::CommandLine.runner
    end

    # Sets Terrapin's runner engine
    #
    # @param terrapin_runner [CommandLineRunner] backend runner class
    # @return [Object] whatever Terrapin::CommandLine.runner= returns.
    def backend_runner=(terrapin_runner)
      Terrapin::CommandLine.runner = terrapin_runner
    end

    # Returns the command string without running anything
    #
    # @return [String] command line string
    def to_command
      terrapin_line(options_to_commands).command(@options.store)
    end
    alias_method :command, :to_command

    # Runs the command
    #
    # @return [String] the output of youtube-dl
    def run
      terrapin_line(options_to_commands).run(@options.store)
    end
    alias_method :download, :run

    # Options configuration.
    # Just aliases to options.configure
    #
    # @yield [config] options
    # @param a [Array] arguments to pass to options#configure
    # @param b [Proc] block to pass to options#configure
    def configure(*a, &b)
      options.configure(*a, &b)
    end

    private

    # Parses options and converts them to Terrapin's syntax
    #
    # @return [String] commands ready to do terrapin
    def options_to_commands
      commands = []
      @options.sanitize_keys.each_paramized_key do |key, paramized_key|
        if @options[key].to_s == 'true'
          commands.push "--#{paramized_key}"
        elsif @options[key].to_s == 'false'
          commands.push "--no-#{paramized_key}"
        else
          commands.push "--#{paramized_key} :#{key}"
        end
      end
      commands.push quoted(url)
      commands.join(' ')
    end
  end
end
