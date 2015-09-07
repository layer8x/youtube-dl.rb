require_relative '../test_helper'

module OutputFactory
  module_function
  include YoutubeDL::Support

  def download
    @download ||= cocaine_line(TEST_URL).run
  end

  def list_formats
    @list_formats ||= cocaine_line('--list-formats').run
  end
end

describe YoutubeDL do
  describe '#initialize' do
    it 'should set the output variable'
  end

  describe '#supported_formats' do
    it 'should find a match given the correct output'
    it 'should find the correct match'
    it 'should return the correct format'
  end

  describe '#filename' do
    it 'should find a match given the correct output'
    it 'should find the correct match'
  end

  describe 'already_downloaded?' do
    it 'should return a truthy value if true'
    it 'should return a falsy value if false'
  end
end
