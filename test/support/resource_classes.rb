class MyResource < Struct.new(:id, :title)
  def self.cache_key
    'cache_key'
  end

  def self.find(value)
  end
end
