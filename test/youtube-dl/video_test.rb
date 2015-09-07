require_relative '../test_helper'

describe YoutubeDL::Video do
  describe '.download' do
    after do
      remove_downloaded_files
    end

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
    after do
      remove_downloaded_files
    end

    it 'should download videos, exactly like .download' do
      YoutubeDL::Video.get TEST_URL
      assert_equal Dir.glob(TEST_GLOB).length, 1
    end
  end

  describe '#initialize' do
    after do
      remove_downloaded_files
    end

    it 'should return an instance of YoutubeDL::Video' do
      video = YoutubeDL::Video.new TEST_URL

      assert_instance_of YoutubeDL::Video, video
    end
  end
end
