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
  end

  describe '#formats' do
    before do
      @formats = @video.formats
    end

    it 'should be an Array' do
      assert_instance_of Array, @formats
    end

    it 'should be an Array of Hashes' do
      @formats.each do |f|
        assert_instance_of Hash, f
      end
    end

    it 'should have a hash size of 4' do
      assert_equal 4, @formats.first.size
    end

    it 'should include the correct information' do
      [:format_code, :resolution, :extension, :note].each do |key|
        assert_includes @formats.first, key
        assert_includes @formats.last, key
      end
    end

    it 'should not have any whitespace in the notes' do
      @formats.each do |format|
        assert_nil format[:note].strip!
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

    it 'should give the correct filename when run through ffmpeg' do
      @video.configure do |c|
        c.output = '%(id)s.%(ext)s'
        c.extract_audio = true
        c.audio_format = 'mp3'
      end
      @video.download
      assert_equal "#{TEST_ID}.mp3", @video.filename
    end
  end
end
