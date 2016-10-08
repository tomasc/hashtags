require 'test_helper'

describe Hashtags::Resource do
  let(:res_1) { ::MyResource.new('123', 'Resource 1') }
  let(:res_2) { ::MyResource.new('456', 'Resource 2') }

  let(:str) { "Resources: #my_resource:#{res_1.title}(#{res_1.id}) & #my_resource:#{res_2.title}(#{res_2.id})" }

  subject { MyResourceTag.new(str) }

  it { MyResourceTag.cache_key.must_equal MyResource.cache_key }

  describe '.resource_as_json' do
    it 'returns json for resource' do
      MyResourceTag.resource_as_json(res_1).must_equal(option: res_1.title, tag: res_1.title, id: res_1.id)
    end
  end

  describe '#to_markup' do
    it 'should replace hastags with markup' do
      find_result = lambda do |id|
        case id
        when res_1.id then res_1
        when res_2.id then res_2
        end
      end

      ::MyResource.stub(:find, find_result) do
        subject.to_markup.must_equal "Resources: #{res_1.title} & #{res_2.title}"
      end
    end
  end

  describe '#to_hash_tag' do
    it 'updates the original str with new values' do
      res_1.title = 'Sunny'
      subject.to_hash_tag.must_equal "Resources: #my_resource:Sunny(#{res_1.id}) & #my_resource:#{res_2.title}(#{res_2.id})"
    end
  end
end
