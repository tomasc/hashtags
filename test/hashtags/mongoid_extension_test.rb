require 'test_helper'

describe 'Mongoid extensions' do
  let(:user) { ::User.new('JTschichold', 'Jan Tschichold') }
  let(:user_tag) { "@#{user.id}" }
  let(:user_result) { user }

  let(:str) { "User tag: #{user_tag}" }
  let(:doc) { ExtensionDoc.new(text: str) }

  it 'returns value as usual' do
    doc.text.must_equal str
  end

  it 'preserves the field type' do
    doc.text.must_be_kind_of doc.class.fields['text'].type
  end

  describe '#to_markup' do
    it { doc.text.must_respond_to :to_markup }

    it 'converts value to markup' do
      ::User.stub(:find, user_result) do
        doc.text.to_markup.must_equal "User tag: #{user.name}"
      end
    end
  end

  describe '#to_hashtag' do
    it { doc.text.must_respond_to :to_hashtag }

    it 'converts value to hashtag' do
      user.id = 'Sunny'
      ::User.stub(:find, user_result) do
        doc.text.to_hashtag.must_equal 'User tag: @Sunny'
      end
    end
  end

  describe '.hashtags' do
    it { ExtensionDoc.hashtags.must_be_kind_of Hash }
    it { ExtensionDoc.hashtags['text'].dom_data.must_be_kind_of Hash }
    it { ExtensionDoc.hashtags['text'].help.must_be_kind_of Array }
    it { ExtensionDoc.hashtags['text'].options.must_equal({}) }
  end
end
