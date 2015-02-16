module YoutubeDL
  class Options
    attr_accessor :store

    def initialize
      @store = {}
    end

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

    def configure(&block)
      block.call(self)
    end

    def [](key)
      @store[key.to_sym]
    end

    def []=(key, value)
      @store[key.to_sym] = value
    end

    def method_missing(method, *args, &block)
      if method.to_s.include? '='
        method = method.to_s.tr('=', '').to_sym
        @store[method] = args.first
      else
        @store[method]
      end
    end

    def symbolize_keys!
      @store.keys.each do |key_name|
        unless key_name.is_a? Symbol
          @store[key_name.to_sym] = @store[key_name]
          @store.delete(key_name)
        end
      end
    end

    private
    def paramize(key)
      key.to_s.tr("_", '-')
    end
  end
end
