require_relative './test_helper'

describe YoutubeDL do
  describe '::VERSION' do
    let(:version) { YoutubeDL::VERSION }

    it 'is a valid Rubygem version' do
      assert Gem::Version.correct?(version), "Malformed version number string #{version}"
    end

    it 'is the correct format' do
      assert_match(/\d+.\d+.\d+.\d{4}\.\d+\.\d+\.?\d+?/, version)
    end
  end

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

  describe '.extractors' do
    before do
      @extractors = YoutubeDL.extractors
    end

    it 'should return an Array' do
      assert_instance_of Array, @extractors
    end

    it 'should include the youtube extractors' do
      ['youtube', 'youtube:channel', 'youtube:search', 'youtube:show', 'youtube:user', 'youtube:playlist'].each do |e|
        assert_includes @extractors, e
      end
    end
  end

  describe '.binary_version' do
    before do
      @version = YoutubeDL.binary_version
    end

    it 'should return a string' do
      assert_instance_of String, @version
    end

    it 'should be a specific format with no newlines' do
      assert_match /\d+.\d+.\d+\z/, @version
    end
  end

  describe '.user_agent' do
    before do
      @user_agent = YoutubeDL.user_agent
    end

    it 'should return a string' do
      assert_instance_of String, @user_agent
    end

    it 'should be a specific format with no newlines' do
      assert_match /Mozilla\/5\.0\s.*\)\z/, @user_agent
    end
  end
end
