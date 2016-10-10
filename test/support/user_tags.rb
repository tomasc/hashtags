class UserTag < Hashtags::User
  def self.resource_class
    ::User
  end

  def self.tag_attribute
    :id
  end

  def self.result_attribute
    :name
  end

  def resource(value)
    self.class.resource_class.find(value)
  end
end
