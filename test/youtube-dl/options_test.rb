require_relative '../test_helper'

describe YoutubeDL::Options do
  before do
    @options = YoutubeDL::Options.new
  end

  it 'should symbolize option keys' do
    @options.store['key'] = "value"
    @options.sanitize_keys!
    assert_equal({key: 'value'}, @options.store)
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

  it 'should properly paramize keys and not values' do
    @options.some_key = "some value"

    @options.each_paramized do |key, value|
      assert_equal key, 'some-key'
      assert_equal value, 'some value'
    end
  end

  it 'should make each_paramized_key work' do # TODO: Write a better test name
    @options.some_key = "some value"

    @options.each_paramized_key do |key, paramized_key|
      assert_equal :some_key, key
      assert_equal 'some-key', paramized_key
    end
  end

  it 'should convert hyphens to underscores in keys' do # See issue #9
    @options.store[:"hyphenated-key"] = 'value'
    @options.sanitize_keys!
    assert_equal({hyphenated_key: 'value'}, @options.to_h)
  end
end
