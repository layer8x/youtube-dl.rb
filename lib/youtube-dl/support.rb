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

    # Custom implementation of symbolize_names so it won't symbolize things like HTTP headers.
    #
    # @param unsymbolized_hash [Hash] hash to symbolize
    # @return [Hash] hash with symbolized keys
    def symbolize_json(unsymbolized_hash)
      {}.tap do |new_hash|
        unsymbolized_hash.each do |key, value|
          if key[0] =~ /[a-z]|_/ # Is key capitalized?
            new_hash[key.to_sym] = _transform_object(value)
          else
            new_hash[key] = _transform_object(value)
          end
        end
      end
    end

    # :nodoc:
    # Helper for symbolize_json
    def _transform_object(value)
      case value
      when Hash
        symbolize_json(value)
      when Array
        value.map { |v| _transform_object(v) }
      else
        value
      end
    end
  end
end
