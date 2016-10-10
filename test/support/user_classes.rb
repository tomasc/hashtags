class User < Struct.new(:id, :name)
  def self.cache_key
    'cache_key'
  end

  def self.find(value)
  end

  def to_s
    name
  end
end
