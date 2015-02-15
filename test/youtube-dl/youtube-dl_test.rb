require 'test_helper'

describe YoutubeDL do
  before do
    @dl = YoutubeDL.new
  end

  it 'does some stuff' do
    assert_equal @dl.test, "test"
  end
end
