module YoutubeDL
  module Support
    # Some support methods and glue logic.

    # Returns a usable youtube-dl executable (system or vendor)
    #
    # @param exe [String] Executable to search for
    # @return [String] executable path
    def usable_executable_path_for(exe)
      system_path = `which #{exe} 2> /dev/null` # This will currently only work on Unix systems. TODO: Add Windows support
      if $?.exitstatus == 0 # $? is an object with information on that last command run with backticks.
        system_path.strip
      else
        # TODO: Search vendor bin for executable before just saying it's there.
        vendor_path = File.absolute_path("#{__FILE__}/../../../vendor/bin/#{exe}")
        File.chmod(775, vendor_path) unless File.executable?(vendor_path) # Make sure vendor binary is executable
        vendor_path
      end
    end

    alias_method :executable_path_for, :usable_executable_path_for

    # Helper for doing lines of cocaine (initializing, auto executable stuff, etc)
    #
    # @param command [String] command switches to run
    # @param executable_path [String] executable to run. Defaults to usable youtube-dl.
    # @return [Cocaine::CommandLine] initialized Cocaine instance
    def cocaine_line(command, executable_path = nil)
      executable_path = executable_path_for('youtube-dl') if executable_path.nil?
      Cocaine::CommandLine.new(executable_path, command)
    end

    # Helper to add quotes to beginning and end of a URL or whatever you want....
    #
    # @param url [String] Raw URL
    # @return [String] Quoted URL
    def quoted(url)
      "\"#{url}\""
    end
  end
end
