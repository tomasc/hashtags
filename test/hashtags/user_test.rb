require 'test_helper'

describe Hashtags::User do
  let(:user_1) { ::User.find('JTschichold') }
  let(:user_2) { ::User.find('KGerstner') }
  let(:str) { "Say hello to @#{user_1.id} and @#{user_2.id}!" }

  subject { UserTag.new(str) }

  it { UserTag.cache_key.must_equal User.cache_key }

  describe '#to_markup' do
    it { subject.to_markup.must_equal "Say hello to #{user_1.name} and #{user_2.name}!" }
  end

  describe '#to_hashtag' do
    before { user_1.id = 'Sunny' }
    it { subject.to_hashtag.must_equal "Say hello to @Sunny and @#{user_2.id}!" }
  end
end
