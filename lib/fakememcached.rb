require 'fakememcached/cache_entry'

class FakeMemcached
  def initialize(servers = nil, opts = {})
    @servers = servers
    @default_ttl = opts[:default_ttl] || 1_000_000
    @data = {}
  end

  # NOT IMPLEMENTED:
  # * cas
  # * get_from_last
  # * prepend
  # * quit
  # * replace
  # * server_by_key
  # * set_servers
  # * set_prefix_key

  def prefix_key
    ""
  end
  alias :namespace :prefix_key
  
  def set(key, value, ttl = nil, marshal = true, flags = nil)
    @data[key] = CacheEntry.new(value, ttl.nil? || ttl.zero? ? @default_ttl : ttl, marshal)
  end

  def add(key, value, ttl = @default_ttl, marshal = true, flags = nil)
    if has_unexpired_key?(key)
      "NOT_STORED\r\n"
    else
      set(key, value, ttl, marshal, flags)
      "STORED\r\n"
    end
  end

  def get(key, marshal = true)
    if key.is_a?(Array)
      @data.slice(*key).collect { |k,v| [k, v.unmarshal] }.to_hash_without_nils
    else
      return nil unless has_unexpired_key?(key)
      
      if marshal
        @data[key].unmarshal
      else
        @data[key].value
      end
    end
  end

  def increment(key, offset = 1)
    if has_unexpired_key?(key)
      @data[key].increment(offset)
      @data[key].to_i
    end
  end
  alias :incr :increment

  def decrement(key, amount = 1)
    if has_unexpired_key?(key)
      @data[key].decrement(amount)
      @data[key].to_i
    end
  end
  alias :decr :decrement

  def append(key, value)
    set(key, get(key, false).to_s + value.to_s, nil, false)
  end
  
  def delete(key)
    @data.delete(key) if has_unexpired_key?(key)
  end

  def servers
    @servers
  end

  def flush
    @data.clear
  end
  alias :flush_all :flush

  def reset(current_servers = nil)
    @servers = current_servers
  end

  def stats(subcommand = nil)
    {}
  end

  private
    def has_unexpired_key?(key)
      @data.has_key?(key) && !@data[key].expired?
    end
end
