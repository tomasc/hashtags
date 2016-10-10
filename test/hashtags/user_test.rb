require 'test_helper'

describe Hashtags::User do
  let(:user_1) { ::User.new('JTschichold', 'Jan Tschichold') }
  let(:user_2) { ::User.new('KGerstner', 'Karl Gerstner') }
  let(:str) { "Say hello to @#{user_1.id} and @#{user_2.id}!" }

  subject { UserTag.new(str) }

  it { UserTag.cache_key.must_equal User.cache_key }

  describe '#to_markup' do
    it 'should replace hastags with markup' do
      find_result = lambda do |id|
        case id
        when user_1.id then user_1
        when user_2.id then user_2
        end
      end

      ::User.stub(:find, find_result) do
        subject.to_markup.must_equal "Say hello to #{user_1.name} and #{user_2.name}!"
      end
    end
  end

  describe '#to_hashtag' do
    it 'updates the original str with new values' do
      user_1.id = 'Sunny'
      subject.to_hashtag.must_equal "Say hello to @Sunny and @#{user_2.id}!"
    end
  end
end
