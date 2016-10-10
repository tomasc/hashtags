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

  def resource(value)
    self.class.resource_class.find(value)
  end
end
