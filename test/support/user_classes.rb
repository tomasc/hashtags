class User < Struct.new(:id, :name)
  def self.cache_key
    'cache_key'
  end

  def self.all
    [
      new('JTschichold', 'Jan Tschichold'),
      new('KGerstner', 'Karl Gerstner')
    ]
  end

  def self.find(id)
    all.detect { |i| i.id == id.to_s }
  end

  def to_s
    name
  end
end
