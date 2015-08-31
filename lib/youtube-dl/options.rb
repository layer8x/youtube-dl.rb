module YoutubeDL
  class Options
    attr_accessor :store

    # Options initializer
    #
    # @param options [Hash] a hash of options
    def initialize(options={})
      @store = options
    end

    # Returns options as a hash
    #
    # @return [Hash] hash of options
    def to_hash
      @store
    end
    alias_method :to_h, :to_hash

    def each_paramized
      @store.each do |key, value|
        yield(paramize(key), value)
      end
    end

    def each_paramized_key
      @store.each_key do |key|
        yield(key, paramize(key))
      end
    end

    # Set options using a block
    def configure(&block)
      block.call(self)
    end

    # Get option with brackets syntax
    def [](key)
      @store[key.to_sym]
    end

    # Set option with brackets syntax
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

    # Symbolizes and sanitizes keys in the option store
    def sanitize_keys!
      # Symbolize
      manipulate_keys! { |key_name| key_name.is_a?(Symbol) ? key_name : key_name.to_sym }

      # Underscoreize
      manipulate_keys! { |key_name| key_name.to_s.tr('-', '_').to_sym }
    end

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

    def manipulate_keys!(&block)
      @store.keys.each do |old_name|
        new_name = block.call(old_name)
        unless new_name == old_name
          @store[new_name] = @store[old_name]
          @store.delete(old_name)
        end
      end
    end
  end
end
