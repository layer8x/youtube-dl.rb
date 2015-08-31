require_relative '../test_helper'

describe YoutubeDL do
  after do
    remove_downloaded_files
  end

  it 'should download videos' do
    YoutubeDL.get TEST_URL, output: TEST_FILENAME, format: TEST_FORMAT
    assert File.exist? TEST_FILENAME
  end

  it 'should download multiple videos' do
    YoutubeDL.download [TEST_URL, TEST_URL2]
    assert_equal Dir.glob(TEST_GLOB).length, 2
  end
end
