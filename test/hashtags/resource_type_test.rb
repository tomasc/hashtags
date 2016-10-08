require 'test_helper'

describe Hashtags::ResourceType do
  subject { Hashtags::ResourceType }

  it { subject.resource_classes.must_equal [MyResourceTag] }
end
