require_relative '../test_helper'

describe YoutubeDL::Output do
  describe '#initialize' do
    it 'should set the output variable' do
      sample_output = "some sample output\n\n"
      parser = YoutubeDL::Output.new(sample_output)
      assert_equal sample_output, parser.output
    end
  end

  describe '#supported_formats' do
    before do
      @parser = YoutubeDL::Output.new(fixture(:output, :list_formats))
    end

    it 'should find a match given the correct output' do
      refute_nil @parser.supported_formats
    end

    it 'should find the correct match and in the correct format' do
      assert_includes(@parser.supported_formats, {format_code: 5, extension: 'flv', resolution: '400x240', note: 'small'})
    end

    it 'should return nil if no match or wrong log format' do
      bad_parser = YoutubeDL::Output.new(fixture(:output, :download))
      assert_nil bad_parser.supported_formats
    end
  end

  describe '#filename' do
    before do
      @parser_download = YoutubeDL::Output.new(fixture(:output, :download))
      @parser_download_ffmpeg = YoutubeDL::Output.new(fixture(:output, :download_ffmpeg))
      @parser_download_exists = YoutubeDL::Output.new(fixture(:output, :download_exists))
      @parser_download_audio = YoutubeDL::Output.new(fixture(:output, :download_audio))
    end

    it 'should find a match given the correct output' do
      refute_nil @parser_download.filename
      refute_nil @parser_download_ffmpeg.filename
      refute_nil @parser_download_exists.filename
      refute_nil @parser_download_audio.filename
    end

    it 'should find the correct match' do
      assert_equal 'nope.avi-gvdf5n-zI14.mp4', @parser_download.filename
      assert_equal 'nope.avi-gvdf5n-zI14.mp4', @parser_download_ffmpeg.filename
      assert_equal 'nope.avi-gvdf5n-zI14.mp4', @parser_download_exists.filename
      assert_equal 'nope-gvdf5n-zI14.mp3', @parser_download_audio.filename
    end

    it 'should return nil if no match or wrong log format' do
      bad_parser = YoutubeDL::Output.new(fixture(:output, :list_formats))
      assert_nil bad_parser.filename
    end
  end

  describe '#already_downloaded?' do
    before do
      @parser_download = YoutubeDL::Output.new(fixture(:output, :download))
      @parser_download_ffmpeg = YoutubeDL::Output.new(fixture(:output, :download_ffmpeg))
      @parser_download_exists = YoutubeDL::Output.new(fixture(:output, :download_exists))
    end

    it 'should return a truthy value if true' do
      assert @parser_download_exists.already_downloaded?
    end

    it 'should return a falsy value if false' do
      refute @parser_download.already_downloaded?
      refute @parser_download_ffmpeg.already_downloaded?
    end
  end
end
