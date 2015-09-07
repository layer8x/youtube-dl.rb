module YoutubeDL
  # A class of voodoo methods for parsing youtube-dl output
  class Output < Struct.new(:output)
    # Takes the output of '--list-formats'
    #
    # @return [Array] Array of supported formats
    def supported_formats
      # WARNING: This shit won't be documented or even properly tested. It's almost 3 in the morning and I have no idea what I'm doing.
      formats = []
      output.slice(output.index('format code')..-1).split("\n").each do |line|
        format = {}
        format[:format_code], format[:extension], format[:resolution], format[:note] = line.scan(/\A(\d+)\s+(\w+)\s+(\S+)\s(.*)/)[0]
        formats.push format
      end
      formats.shift # The first line is just headers
      formats.map { |format| format[:note].strip!; format } # Get rid of any trailing whitespace on the note.
    end

    # Takes the output of a download
    #
    # @return [String] filename saved
    def filename
      # Check to see if file was already downloaded
      if already_downloaded?
        output.scan(/\[download\]\s(.*)\shas already been downloaded and merged/)[0][0]
      else
        output.scan(/Merging formats into \"(.*)\"/)[0][0]
      end
    rescue NoMethodError
      nil
    end

    # Takes the output of a download
    #
    # @return [Boolean] Has the file already been downloaded?
    def already_downloaded?
      output.include? 'has already been downloaded and merged'
    end
  end
end
