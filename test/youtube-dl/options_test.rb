require_relative '../test_helper'

describe YoutubeDL::Options do
  let(:example_pair) { {parent_key: 'parent value'} }
  let(:banned_pair) { {banned_key: 'Outlaw Country! Whoo!'} }

  before do
    @options = YoutubeDL::Options.new
    @options.banned_keys.push :banned_key
  end

  describe '#initialize' do
    it 'should symbolize option keys' do
      @options.store['key'] = "value"
      @options.sanitize_keys!
      assert_equal({key: 'value'}, @options.store)
    end

    it 'should accept a parent Options as a param' do
      parent = YoutubeDL::Options.new(parent_key: 'parent value')
      child = YoutubeDL::Options.new(parent)
      assert_equal parent.store, child.store
    end

    it 'should accept a Hash as a param' do
      hash = {parent_key: 'parent value'}
      options = YoutubeDL::Options.new(hash)
      assert_equal hash, options.store
    end
  end

  describe '#to_hash, #to_h' do
    before do
      @options.store[:key] = "value"
    end

    it 'should return a hash' do
      assert_instance_of Hash, @options.to_hash
    end

    it 'should be equal to store' do
      assert_equal @options.store, @options.to_hash
    end

    it 'should not include banned keys' do
      @options.store.merge! banned_pair
      refute_includes @options.to_h, :banned_key
    end
  end

  describe '#each_paramized' do
    it 'should properly paramize keys and not values' do
      @options.some_key = "some value"

      @options.each_paramized do |key, value|
        assert_equal key, 'some-key'
        assert_equal value, 'some value'
      end
    end
  end

  describe '#each_paramized_key' do
    it 'should properly paramize keys' do # TODO: Write a better test name
      @options.some_key = "some value"

      @options.each_paramized_key do |key, paramized_key|
        assert_equal :some_key, key
        assert_equal 'some-key', paramized_key
      end
    end
  end

  describe '#configure' do
    it 'should be able to use an explicit configuration block' do
      @options.configure do |c|
        c.get_operator = true
        c['get_index'] = true
      end

      assert @options.store[:get_operator], "Actual: #{@options.store[:get_operator]}"
      assert @options.store[:get_index], "Actual: #{@options.store[:get_index]}"
    end

    it 'should not override parent configuration' do
      opts = YoutubeDL::Options.new(parent: 'value')
      opts.configure do |c|
        c.child = 'vlaue'
      end

      assert_equal opts.store[:parent], 'value'
      assert_equal opts.store[:child], 'vlaue'
    end

    it 'should remove any banned keys automatically' do
      @options.configure do |c|
        c.parent_key = 'parent value'
        c.banned_key = 'nope'
      end

      assert_equal example_pair, @options.store
    end
  end

  describe '#[], #[]==' do
    it 'should be able to use brackets' do
      @options[:mtn] = :dew
      assert @options[:mtn] == :dew
    end

    it 'should automatically symbolize keys' do
      @options.get_operator = true
      @options['get_index'] = true

      [:get_operator, :get_index].each do |d|
        assert @options.store.keys.include?(d), "keys not symbolizing automatically: #{d}"
      end
    end

    it 'should remove any banned keys automatically' do
      @options[:banned_key] = 'nope'
      refute_includes @options.store, :banned_key
    end

    it 'should not return any banned keys' do
      @options.store.merge! banned_pair
      assert_nil @options[:banned_key]
    end
  end

  describe '#with' do
    let(:addon_pair) { {secondary_key: 'secondary value'} }

    before do
      @options.store.merge! example_pair
    end

    it 'should merge @store and given hash' do
      assert_equal example_pair.merge(addon_pair), @options.with(addon_pair).to_h
    end

    it 'should not affect @store directly' do
      @options.with(addon_pair)
      assert_equal example_pair, @options.store
    end

    it 'should not include banned keys' do
      refute_includes @options.with(banned_pair).to_h, :banned_key
    end
  end

  describe '#method_missing' do
    it 'should be able to set options with method_missing' do
      @options.test = true

      assert @options.store[:test]
    end

    it 'should be able to retrieve options with method_missing' do
      @options.store[:walrus] = 'haswalrus'

      assert @options.walrus == 'haswalrus'
    end

    it 'should remove any banned keys automatically' do
      @options.banned_key = 'nope'
      refute_includes @options.store, :banned_key
    end

    it 'should not return any banned keys' do
      @options.store.merge! banned_pair
      assert_nil @options.banned_key
    end
  end

  describe '#manipulate_keys!' do
    it 'should manipulate keys' do
      @options.some_key = 'value'
      @options.manipulate_keys! do |key|
        key.to_s.upcase
      end
      assert_equal({'SOME_KEY' => 'value'}, @options.store)
    end
  end

  describe '#sanitize_keys!' do
    it 'should convert hyphens to underscores in keys' do # See issue #9
      @options.store[:"hyphenated-key"] = 'value'
      @options.sanitize_keys!
      assert_equal({hyphenated_key: 'value'}, @options.to_h)
    end
  end

  describe '#sanitize_keys' do
    it 'should not modify the original by calling sanitize_keys without bang' do
      @options.store['some-key'] = "some_value"
      refute_equal @options.sanitize_keys, @options
    end

    it 'should return instance of Options when calling sanitize_keys' do
      @options.store['some-key'] = "some_value"
      assert_instance_of YoutubeDL::Options, @options.sanitize_keys
    end
  end

  describe '#banned?' do
    it 'should return true for a banned key' do
      assert @options.banned?(:banned_key), "Key :banned_key was not banned"
    end

    it 'should return false for a not banned key' do
      refute @options.banned?(:not_banned_key), "Key :not_banned_key was banned"
    end
  end
end
