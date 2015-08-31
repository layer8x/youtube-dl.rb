require_relative '../test_helper'

describe YoutubeDL do
  describe '.download' do
    after do
      remove_downloaded_files
    end

    it 'should download videos' do
      YoutubeDL.get TEST_URL, output: TEST_FILENAME, format: TEST_FORMAT
      assert File.exist? TEST_FILENAME
    end

    it 'should download multiple videos' do
      YoutubeDL.download [TEST_URL, TEST_URL2]
      assert_equal Dir.glob('nope*').length, 2
    end
  end

  describe '.extractors' do
    it 'should return an Array of Strings' do
      extractors = YoutubeDL.extractors
      assert_instance_of Array, extractors
      assert_instance_of String, extractors.first
    end
  end
end
