require_relative '../test_helper'

describe YoutubeDL::Video do
  describe '.download' do
    after do
      remove_downloaded_files
    end

    it 'should download videos without options' do
      YoutubeDL.download TEST_URL
      assert_equal 1, Dir.glob(TEST_GLOB).length
    end

    it 'should download videos with options' do
      YoutubeDL.download TEST_URL, output: TEST_FILENAME, format: TEST_FORMAT
      assert File.exist? TEST_FILENAME
    end

    it 'should download multiple videos without options' do
      YoutubeDL.download [TEST_URL, TEST_URL2]
      assert_equal 2, Dir.glob(TEST_GLOB).length
    end

    it 'should download multiple videos with options' do
      YoutubeDL.download [TEST_URL, TEST_URL2], output: 'test_%(title)s-%(id)s.%(ext)s'
      assert_equal 2, Dir.glob('test_' + TEST_GLOB).length
    end
  end

  describe '.get' do
    after do
      remove_downloaded_files
    end

    it 'should download videos, exactly like .download' do
      YoutubeDL.get TEST_URL
      assert_equal Dir.glob(TEST_GLOB).length, 1
    end
  end
end
