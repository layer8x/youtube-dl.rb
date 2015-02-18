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

    # Symbolizes keys in the option store
    def symbolize_keys!
      @store.keys.each do |key_name|
        unless key_name.is_a? Symbol
          @store[key_name.to_sym] = @store[key_name]
          @store.delete(key_name)
        end
      end
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
