require 'cocaine'

module YoutubeDL
  class Runner
    attr_accessor :url
    attr_accessor :options
    attr_accessor :executable_path

    # Command Line runner initializer
    #
    # @param url [String] URL to pass to youtube-dl executable
    # @param options [Hash, Options] options to pass to the executable. Automatically converted to Options if it isn't already
    def initialize(url, options=YoutubeDL::Options.new)
      @url = url
      @options = YoutubeDL::Options.new(options.to_hash)
      @executable_path = usable_executable_path
    end

    # Returns Cocaine's runner engine
    #
    # @return [CommandLineRunner] backend runner class
    def backend_runner
      Cocaine::CommandLine.runner
    end

    # Sets Cocaine's runner engine
    #
    # @param [CommandLineRunner] backend runner class
    def backend_runner=(cocaine_runner)
      Cocaine::CommandLine.runner = cocaine_runner
    end

    # Returns the command string without running anything
    #
    # @return [String] command line string
    def to_command
      cocaine_line(options_to_commands).command(@options.store)
    end
    alias_method :command, :to_command

    # Runs the command
    def run
      cocaine_line(options_to_commands).run(@options.store)
    end

    private

    # Parses options and converts them to Cocaine's syntax
    #
    # @return [String] commands ready to do cocaine
    def options_to_commands
      commands = []
      options.each_paramized_key do |key, paramized_key|
        if options[key].to_s == 'true'
          commands.push "--#{paramized_key}"
        else
          commands.push "--#{paramized_key} :#{key}"
        end
      end
      commands.push url
      commands.join(' ')
    end

    # Helper for doing lines of cocaine (initializing, auto executable stuff, etc)
    #
    # @param command [String] command switches to run
    # @return [Cocaine::CommandLine] initialized Cocaine instance
    def cocaine_line(command)
      Cocaine::CommandLine.new(@executable_path, command)
    end

    # Returns a usable executable (system or vendor)
    #
    # @return [String] youtube-dl executable path
    def usable_executable_path
      system_path = `which youtube-dl`
      if $?.exitstatus == 0
        system_path
      else
        File.absolute_path("#{__FILE__}/../../../vendor/bin/youtube-dl")
      end
    end
  end
end
