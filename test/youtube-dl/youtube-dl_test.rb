require_relative '../test_helper'

describe YoutubeDL do
  after do
    remove_downloaded_files
  end

  it 'should download videos' do
    YoutubeDL.get NOPE, output: 'nope.avi'
    assert File.exist? 'nope.avi'
  end
end
