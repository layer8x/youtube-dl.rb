module YoutubeDL
  # A class of voodoo methods for parsing youtube-dl output
  class Output
    # @return [String] Whatever youtube-dl spat out.
    attr_accessor :output

    # Initialize output parser
    #
    # @param output [String] Whatever youtube-dl spat out.
    # @return [YoutubeDL::Output] self
    def initialize(output)
      @output = output
    end

    # Takes the output of '--list-formats'
    #
    # @return [Array] Array of supported formats
    def supported_formats
      # WARNING: This shit won't be documented or even properly tested. It's almost 3 in the morning and I have no idea what I'm doing.
      header_index = output.index('format code')
      return nil if header_index.nil?

      formats = []
      output.slice(header_index..-1).split("\n").each do |line|
        format = {}
        format[:format_code], format[:extension], format[:resolution], format[:note] = line.scan(/\A(\d+)\s+(\w+)\s+(\S+)\s(.*)/)[0]
        formats.push format
      end
      formats.shift # The first line is just headers
      formats.map do |format|
        format[:note].strip! # Get rid of any trailing whitespace on the note.
        format[:format_code] = format[:format_code].to_i # convert format code to integer
        format
      end
    end

    # Takes the output of a download
    #
    # @return [String] filename saved, nil if no match
    def filename
      # Check to see if file was already downloaded
      if already_downloaded?
        output.scan(/\[download\]\s(.*)\shas already been downloaded/)[0][0]
      else
        if output.include? 'Merging formats into'
          output.scan(/Merging formats into \"(.*)\"/)[0][0]
        elsif output.include? '[ffmpeg] Destination:'
          output.scan(/\[ffmpeg\] Destination:\s(.*)$/)[0][0]
        else
          output.scan(/\[download\] Destination:\s(.*)$/)[0][0]
        end
      end
    rescue NoMethodError # There wasn't a match somewhere. Kill it with fire
      nil
    end

    # Takes the output of a download
    #
    # @return [Boolean] Has the file already been downloaded?
    def already_downloaded?
      output.include? 'has already been downloaded'
    end
  end
end
