require 'cocaine'

module YoutubeDL
  class Runner
    include YoutubeDL::Support

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
      @executable_path = usable_executable_path_for('youtube-dl')
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
    alias_method :download, :run

    # Returns a list of supported formats for the video in the form of
    # [{:format_code => '000', :extension => 'avi', :resolution => '320x240', :note => 'More details about the format'}]
    #
    # @return [Array] Format list
    def formats
      # TODO: Move formats to its own model?
      parse_format_output(cocaine_line("--list-formats #{quoted(url)}").run)
    end

    private

    # Parses options and converts them to Cocaine's syntax
    #
    # @return [String] commands ready to do cocaine
    def options_to_commands
      commands = []
      options.sanitize_keys.each_paramized_key do |key, paramized_key|
        if options[key].to_s == 'true'
          commands.push "--#{paramized_key}"
        elsif options[key].to_s == 'false'
          commands.push "--no-#{paramized_key}"
        else
          commands.push "--#{paramized_key} :#{key}"
        end
      end
      commands.push quoted(url)
      commands.join(' ')
    end

    # Helper to add quotes to beginning and end of a URL.
    #
    # @param url [String] Raw URL
    # @return [String] Quoted URL
    def quoted(url)
      "\"#{url}\""
    end

    # Helper for doing lines of cocaine (initializing, auto executable stuff, etc)
    #
    # @param command [String] command switches to run
    # @return [Cocaine::CommandLine] initialized Cocaine instance
    def cocaine_line(command)
      Cocaine::CommandLine.new(@executable_path, command)
    end

    # Do you like voodoo?
    #
    # @param format_output [String] output from youtube-dl --list-formats
    # @return [Array] Magic.
    def parse_format_output(format_output)
      # WARNING: This shit won't be documented or even properly tested. It's almost 3 in the morning and I have no idea what I'm doing.
      this_shit = []
      format_output.slice(format_output.index('format code')..-1).split("\n").each do |line|
        a = {}
        a[:format_code], a[:extension], a[:resolution], a[:note] = line.scan(/\A(\d+)\s+(\w+)\s+(\S+)\s(.*)/)[0]
        this_shit.push a
      end
      this_shit.shift
      this_shit.map { |gipo| gipo[:note].strip!; gipo }
    end
  end
end
