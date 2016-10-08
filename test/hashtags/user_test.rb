require 'test_helper'

class User < Struct.new(:name, :id)
  def self.cache_key
    'cache_key'
  end

  def self.find(_username)
  end

  def to_s
    name
  end
end

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

describe Hashtags::User do
  let(:user_1) { ::User.new('Jan Tschichold', 'JTschichold') }
  let(:user_2) { ::User.new('Karl Gerstner', 'KGerstner') }

  let(:str) { "Say hello to @#{user_1.id} and @#{user_2.id}!" }

  subject { UserTag.new(str) }

  it { subject.must_respond_to :str }
  it { UserTag.cache_key.must_equal User.cache_key }
  it { subject.class.regexp.must_be_kind_of Regexp }

  describe '.resource_as_json' do
    it 'returns json for resource' do
      UserTag.resource_as_json(user_1).must_equal(option: user_1.to_s, tag: user_1.id)
    end
  end

  describe '#to_markup' do
    it 'should replace hastags with markup' do
      find_result = lambda do |id|
        case id
        when user_1.id then user_1
        when user_2.id then user_2
        end
      end

      ::User.stub(:find, find_result) do
        subject.to_markup.must_equal "Say hello to #{user_1} and #{user_2}!"
      end
    end
  end

  describe '#to_hash_tag' do
    it 'updates the original str with new values' do
      user_1.id = 'Sunny'
      subject.to_hash_tag.must_equal "Say hello to @Sunny and @#{user_2.id}!"
    end
  end
end
