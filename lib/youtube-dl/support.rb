module YoutubeDL
  # Some support methods and glue logic.
  module Support
    # Returns a usable youtube-dl executable (system or vendor)
    #
    # @param exe [String] Executable to search for
    # @return [String] executable path
    def usable_executable_path_for(exe)
      system_path = which(exe)
      if system_path.nil?
        # TODO: Search vendor bin for executable before just saying it's there.
        vendor_path = File.absolute_path("#{__FILE__}/../../../vendor/bin/#{exe}")
        File.chmod(775, vendor_path) unless File.executable?(vendor_path) # Make sure vendor binary is executable
        vendor_path
      else
        system_path.strip
      end
    end

    alias_method :executable_path_for, :usable_executable_path_for

    # Helper for doing lines of terrapin (initializing, auto executable stuff, etc)
    #
    # @param command [String] command switches to run
    # @param executable_path [String] executable to run. Defaults to usable youtube-dl.
    # @return [Terrapin::CommandLine] initialized Terrapin instance
    def terrapin_line(command, executable_path = nil)
      executable_path = executable_path_for('youtube-dl') if executable_path.nil?
      Terrapin::CommandLine.new(executable_path, command)
    end

    # Helper to add quotes to beginning and end of a URL or whatever you want....
    #
    # @param url [String] Raw URL
    # @return [String] Quoted URL
    def quoted(url)
      "\"#{url}\""
    end

    # Cross-platform way of finding an executable in the $PATH.
    # Stolen from http://stackoverflow.com/a/5471032
    #
    #   which('ruby') #=> /usr/bin/ruby
    #
    # @param cmd [String] cmd to search for
    # @return [String] full path for the cmd
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end
      nil
    end
  end
end
