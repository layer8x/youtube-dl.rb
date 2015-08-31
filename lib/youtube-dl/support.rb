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
  end
end
