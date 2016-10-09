require 'test_helper'

describe Hashtags::ResourceType do
  subject { Hashtags::ResourceType }

  it { subject.resource_classes.must_equal [MyResourceTag] }
  it { subject.values.must_equal [MyResource.to_s.underscore] }
end
