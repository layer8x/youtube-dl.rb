require_relative '../test_helper'

describe YoutubeDL::Video do
  before do
    @video = YoutubeDL::Video.new TEST_URL
  end

  after do
    remove_downloaded_files
  end

  describe '.download' do
    it 'should download videos without options' do
      YoutubeDL::Video.download TEST_URL
      assert_equal 1, Dir.glob(TEST_GLOB).length
    end

    it 'should download videos with options' do
      YoutubeDL::Video.download TEST_URL, output: TEST_FILENAME, format: TEST_FORMAT
      assert File.exist? TEST_FILENAME
    end

    it 'should return an instance of YoutubeDL::Video' do
      video = YoutubeDL::Video.download TEST_URL
      assert_instance_of YoutubeDL::Video, video
    end
  end

  describe '.get' do
    it 'should download videos, exactly like .download' do
      YoutubeDL::Video.get TEST_URL
      assert_equal Dir.glob(TEST_GLOB).length, 1
    end
  end

  describe '#initialize' do
    it 'should return an instance of YoutubeDL::Video' do
      assert_instance_of YoutubeDL::Video, @video
    end

    it 'should not download anything' do
      assert_empty Dir.glob(TEST_GLOB)
    end
  end

  describe '#download' do
    it 'should download the file' do
      assert_equal 0, Dir.glob(TEST_GLOB).length
      @video.download
      assert_equal 1, Dir.glob(TEST_GLOB).length
    end

    it 'should set model variables accordingly' do
      @video.download
      assert_equal Dir.glob(TEST_GLOB).first, @video.filename
    end

    it 'should raise ArgumentError if url is nil or empty' do
      assert_raises ArgumentError do
        YoutubeDL::Video.new(nil).download
      end

      assert_raises ArgumentError do
        YoutubeDL::Video.new('').download
      end
    end
  end

  describe '#filename' do
    before do
      @video.options.configure do |c|
        c.output = TEST_FILENAME
      end
    end

    it 'should be able to get the filename from the output' do
      @video.download
      assert_equal TEST_FILENAME, @video.filename
    end

    it 'should be able to be predicted' do
      predicted_filename = @video.information[:_filename]
      @video.download
      assert_equal predicted_filename, @video.filename
    end

    it 'should not return previously predicted filename' do
      predicted_filename = @video.information[:_filename]
      @video.configure do |c|
        c.output = "#{TEST_FILENAME}.2"
      end
      @video.download
      refute_equal @video.filename, predicted_filename
    end

    # Broken on Travis. Output test should be fine.
    # it 'should give the correct filename when run through ffmpeg' do
    #   skip if travis_ci?
    #   @video.configure do |c|
    #     c.output = 'nope-%(id)s.%(ext)s'
    #     c.extract_audio = true
    #     c.audio_format = 'mp3'
    #   end
    #   @video.download
    #   assert_equal "nope-#{TEST_ID}.mp3", @video.filename
    # end
  end

  describe '#information' do
    before do
      @information = @video.information
    end

    it 'should be an OpenStruct' do
      assert_instance_of OpenStruct, @information
    end

    it 'does not cause unexpected behavior when get_filename is true' do
      @video.options.get_filename = true

      # Test will error out if JSON::ParserError is raised.
      assert_silent do
        @video.download
      end
    end
  end

  describe '#method_missing' do
    it 'should pull values from @information' do
      assert_equal 'youtube', @video.information[:extractor] # Sanity Check
      assert_equal 'youtube', @video.extractor
    end

    it 'should return correct formats for things' do
      assert_instance_of Array, @video.formats
      assert_instance_of Hash, @video.subtitles
    end

    it 'should fail if a method does not exist' do
      assert_raises NoMethodError do
        @video.i_dont_exist
      end
    end
  end
end
