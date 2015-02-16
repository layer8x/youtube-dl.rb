require 'cocaine'

module YoutubeDL
  class Runner
    attr_accessor :url
    attr_accessor :options
    attr_accessor :executable_path

    def initialize(url, options=YoutubeDL::Options.new)
      @url = url
      @options = YoutubeDL::Options.new(options.to_hash)
      @executable_path = 'youtube-dl'
    end

    def backend_runner
      Cocaine::CommandLine.runner
    end

    def backend_runner=(cocaine_runner)
      Cocaine::CommandLine.runner = cocaine_runner
    end

    def to_command
      cocaine_line(options_to_commands).command(@options.store)
    end
    alias_method :command, :to_command

    def run
      cocaine_line(options_to_commands).run(@options.store)
    end

    private
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

    def cocaine_line(command)
      Cocaine::CommandLine.new(@executable_path, command)
    end
  end
end
