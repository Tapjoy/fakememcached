class FakeMemcached
  class CacheEntry
    attr_reader :value
    
    def initialize(value, ttl, marshal)
      if marshal
        @value = singleton_safe_marshal(value)
      else
        @value = value.to_s
      end
      
      @expires_at = Time.now + ttl
    end

    def expired?
      Time.now > @expires_at
    end
    
    def increment(amount = 1)
      @value = (@value.to_i + amount).to_s
    end
    
    def decrement(amount = 1)
      @value = (@value.to_i - amount).to_s
    end

    def unmarshal
      singleton_safe_unmarshal
    end

    def to_i
      @value.to_i
    end

    def singleton_safe_marshal(value)
      # Rspec mocks create singletons out of objects in order to track calls
      # However, singletons can't be dumped, so skip marshaling
      return value if value.singleton_methods.any?
      Marshal.dump(value)
    end

    def singleton_safe_unmarshal
      # Rspec mocks create singletons out of objects in order to track calls
      # However, singletons can't be dumped, so skip marshaling
      return value if value.singleton_methods.any?
      Marshal.load(value)
    end
  end
end
