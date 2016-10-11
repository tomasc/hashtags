class MyResource < Struct.new(:id, :title)
  def self.cache_key
    'cache_key'
  end

  def self.all
    [
      new(1, 'Resource 1'),
      new(2, 'Resource 2')
    ]
  end

  def self.find(id)
    all.detect{ |i| i.id == id.to_i }
  end
end
