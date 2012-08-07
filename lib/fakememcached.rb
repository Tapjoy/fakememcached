require 'fakememcached/cache_entry'

class FakeMemcached
  def initialize(servers = nil, opts = {})
    @default_ttl = opts[:default_ttl] || 1_000_000
    @data = {}
    set_servers(servers)
    set_prefix_key(opts[:prefix_key] || opts[:namespace])
  end

  def set_servers(servers)
    @servers = servers
  end

  def servers
    @servers || []
  end

  def set_prefix_key(prefix_key)
    @prefix_key = prefix_key
  end
  alias :set_namespace :set_prefix_key

  def prefix_key
    @prefix_key || ''
  end
  alias :namespace :prefix_key
  
  def reset(current_servers = nil)
    set_servers(current_servers) if current_servers
  end

  def set(key, value, ttl = @default_ttl, marshal = true, flags = nil)
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

  def increment(key, offset = 1)
    if has_unexpired_key?(key)
      @data[key].increment(offset)
      @data[key].to_i
    end
  end

  def decrement(key, amount = 1)
    if has_unexpired_key?(key)
      @data[key].decrement(amount)
      @data[key].to_i
    end
  end

  alias :incr :increment
  alias :decr :decrement

  def replace(key, value, ttl = @default_ttl, marshal = true, flags = nil)
    if @data.include?(key)
      set(key, value, ttl, marshal, flags)
    else
      raise Memcached::NotFound
    end
  end

  def append(key, value)
    set(key, get(key, false).to_s + value.to_s, nil, false)
  end

  def prepend(key, value)
    set(key, value.to_s + get(key, false).to_s, nil, false)
  end

  def cas(key, ttl = @default_ttl, marshal = true, flags = nil)
    value = get(key, marshal)
    new_value = yield(value)
    if get(key, marshal) == value
      set(key, new_value, ttl, marshal, flags)
    else
      raise Memcached::NotStored
    end
  end
  alias :compare_and_swap :cas
  
  def delete(key)
    @data.delete(key) if has_unexpired_key?(key)
  end

  def flush
    @data.clear
  end
  alias :flush_all :flush

  def reset(current_servers = nil)
    @servers = current_servers
  end

  def quit
    self
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
  alias :get_from_last :get

  def server_by_key(key)
    servers.first
  end

  def stats(subcommand = nil)
    {}
  end

  private
    def has_unexpired_key?(key)
      @data.has_key?(key) && !@data[key].expired?
    end
end
