class MyResource < Struct.new(:id, :title)
  def self.cache_key
    'cache_key'
  end

  def self.find(value)
  end
end

class MyResourceTag < Hashtags::Resource
  def self.resource_class
    ::MyResource
  end

  def self.tag_attribute
    :title
  end

  def self.result_attribute
    :title
  end

  def resource(tag_attribute_value)
    self.class.resource_class.find(tag_attribute_value)
  end
end
