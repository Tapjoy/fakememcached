class FakeMemcache
  class CacheEntry
    attr_reader :value
    
    def initialize(value, ttl, marshal)
      if marshal
        @value = Marshal.dump(value)
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
      Marshal.load(@value)
    end
    
    def to_i
      @value.to_i
    end
  end
end
