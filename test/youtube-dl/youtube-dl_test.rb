require_relative '../test_helper'

describe YoutubeDL do
  after do
    remove_downloaded_files
  end

  it 'should download videos' do
    YoutubeDL.get NOPE, output: 'nope.flv', format: YOUTUBE_DL_FORMAT_FLV
    assert File.exist? 'nope.flv'
  end

  it 'should download multiple videos' do
    YoutubeDL.download [NOPE, "https://www.youtube.com/watch?v=Mt0PUjh-nDM"]
    assert_equal Dir.glob('nope*').length, 2
  end
end
