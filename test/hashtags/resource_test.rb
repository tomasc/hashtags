require 'test_helper'

describe Hashtags::Resource do
  let(:res_1) { ::MyResource.find(1) }
  let(:res_2) { ::MyResource.find(2) }
  let(:str) { "Resources: #my_resource:#{res_1.title}(#{res_1.id}) & #my_resource:#{res_2.title}(#{res_2.id})" }

  subject { MyResourceTag.new(str) }

  it { MyResourceTag.cache_key.must_equal MyResource.cache_key }
  it { Hashtags::Resource.find_by_resource_type(:my_resource).must_equal MyResourceTag }

  describe '#to_markup' do
    it { subject.to_markup.must_equal "Resources: #{res_1.title} & #{res_2.title}" }
  end

  describe '#to_hashtag' do
    before do
      res_1.id = 3
      res_1.title = 'Sunny'
    end
    it { subject.to_hashtag.must_equal "Resources: #my_resource:Sunny(#{res_1.id}) & #my_resource:#{res_2.title}(#{res_2.id})" }
  end
end
