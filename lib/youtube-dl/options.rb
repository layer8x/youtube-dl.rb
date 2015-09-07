module YoutubeDL
  class Options
    attr_accessor :store

    # Options initializer
    #
    # @param options [Hash] a hash of options
    def initialize(options={})
      @store = options.to_hash
    end

    # Returns options as a hash
    #
    # @return [Hash] hash of options
    def to_hash
      @store
    end
    alias_method :to_h, :to_hash

    # Iterate through the paramized keys and values.
    #
    # @yield [paramized_key, value]
    #
    # TODO: Enumerable?
    def each_paramized
      @store.each do |key, value|
        yield(paramize(key), value)
      end
    end

    # Iterate through the keys and their paramized counterparts.
    #
    # @yield [key, paramized_key]
    def each_paramized_key
      @store.each_key do |key|
        yield(key, paramize(key))
      end
    end

    # Set options using a block
    #
    # @yield [config] self
    def configure
      yield(self) if block_given?
    end

    # Get option with brackets syntax
    #
    # @param key [Object] key
    # @return [Object] value
    def [](key)
      @store[key.to_sym]
    end

    # Set option with brackets syntax
    #
    # @param key [Object] key
    # @param value [Object] value
    def []=(key, value)
      @store[key.to_sym] = value
    end

    # Option getting and setting using ghost methods
    def method_missing(method, *args, &block)
      if method.to_s.include? '='
        method = method.to_s.tr('=', '').to_sym
        @store[method] = args.first
      else
        @store[method]
      end
    end

    # Calls a block to do operations on keys
    # See sanitize_keys! for examples
    #
    # @param block [Proc] Block with operations on keys
    # @yieldparam key [Object] Original key
    # @yieldreturn [Object] Manipulated key
    def manipulate_keys!(&block)
      @store.keys.each do |old_name|
        new_name = block.call(old_name)
        unless new_name == old_name
          @store[new_name] = @store[old_name]
          @store.delete(old_name)
        end
      end
    end

    # Symbolizes and sanitizes keys in the option store
    def sanitize_keys!
      # Symbolize
      manipulate_keys! { |key_name| key_name.is_a?(Symbol) ? key_name : key_name.to_sym }

      # Underscoreize (because Cocaine doesn't like hyphens)
      manipulate_keys! { |key_name| key_name.to_s.tr('-', '_').to_sym }
    end

    # Symbolizes and sanitizes keys and returns a copy of self
    #
    # @return [YoutubeDL::Options] Options with sanitized keys.
    def sanitize_keys
      safe_copy = self.dup
      safe_copy.sanitize_keys!
      safe_copy
    end

    private
    # Helper function to convert option keys into command-line-friendly parameters
    #
    # @param key [Symbol, String] key to paramize
    # @return [String] paramized key
    def paramize(key)
      key.to_s.tr("_", '-')
    end
  end
end
