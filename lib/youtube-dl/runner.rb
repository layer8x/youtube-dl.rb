require 'cocaine'

module YoutubeDL
  class Runner
    attr_accessor :options

    def initialize(options)
      @options = options
    end

    def backend_runner
      Cocaine::CommandLine.runner
    end

    def backend_runner=(cocaine_runner)
      Cocaine::CommandLine.runner = cocaine_runner
    end


  end
end
