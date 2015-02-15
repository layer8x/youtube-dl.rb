require_relative '../test_helper'

describe YoutubeDL::Options do
  before do
    @options = YoutubeDL::Options.new
  end

  it 'should symbolize option keys' do
    @options.store['key'] = "value"
    @options.symbolize_keys!
    assert @options.store == {:key => 'value'}
  end

  it 'should be able to set options with method_missing' do
    @options.test = true

    assert @options.store[:test]
  end

  it 'should be able to retrieve options with method_missing' do
    @options.store[:walrus] = 'haswalrus'

    assert @options.walrus == 'haswalrus'
  end

  it 'should be able to use brackets' do
    @options[:mtn] = :dew
    assert @options[:mtn] == :dew
  end

  it 'should be able to use a configuration block' do
    @options.configure do |c|
      c.get_operator = true
      c['get_index'] = true
    end

    assert @options.store[:get_operator], "Actual: #{@options.store[:get_operator]}"
    assert @options.store[:get_index], "Actual: #{@options.store[:get_index]}"
  end

  it 'should automatically symbolize keys' do
    @options.get_operator = true
    @options['get_index'] = true

    [:get_operator, :get_index].each do |d|
      assert @options.store.keys.include?(d), "keys not symbolizing automatically: #{d}"
    end
  end

  it 'should properly paramize keys' do
    @options.some_key = "some value"

    @options.each_paramized do |key, value|
      refute key.include?('_')
      assert_equal value, 'some value'
    end
  end
end
