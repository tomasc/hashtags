require 'test_helper'

describe 'Mongoid extensions' do
  let(:user) { ::User.new('JTschichold', 'Jan Tschichold') }
  let(:user_tag) { "@#{user.id}" }
  let(:user_result) { user }

  let(:str) { "User tag: #{user_tag}" }
  let(:doc) { ExtensionDoc.new(text: str) }
  let(:doc2) { ExtensionDoc2.new(text: str) }

  it { doc.text.must_equal str }
  it { doc.text.must_be_kind_of doc.class.fields['text'].type }

  describe '#to_markup' do
    it { doc.text.must_respond_to :to_markup }

    it 'converts value to markup' do
      ::User.stub(:find, user_result) do
        doc.text.to_markup.must_equal "User tag: #{user.name}"
      end
    end

    it 'does not convert if not supported' do
      ::User.stub(:find, user_result) do
        doc2.text.to_markup.wont_equal "User tag: #{user.name}"
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

    it 'does not convert if not supported' do
      ::User.stub(:find, user_result) do
        doc2.text.to_hashtag.wont_equal 'User tag: @Sunny'
      end
    end
  end

  describe '#used_hashtag_classes' do
    it { doc.text.must_respond_to :used_hashtag_classes }
    it { doc.text.used_hashtag_classes.must_include UserTag }
    it { doc.text.used_hashtag_classes.wont_include VarTag }
  end

  describe '.hashtags' do
    it { ExtensionDoc.hashtags.must_be_kind_of Hash }
    it { ExtensionDoc.hashtags['text'].dom_data.must_be_kind_of Hash }
    it { ExtensionDoc.hashtags['text'].help.must_be_kind_of Array }
    it { ExtensionDoc.hashtags['text'].options.must_equal({}) }

    it { ExtensionDoc2.hashtags.must_be_kind_of Hash }
    it { ExtensionDoc2.hashtags['text'].must_be :present? }

    it { ExtensionDoc3.hashtags.must_be_kind_of Hash }
    it { ExtensionDoc3.hashtags['f1'].must_be :present? }
    it { ExtensionDoc3.hashtags['f2'].must_be :present? }
  end

  describe 'options defined on various classes should not influence each other' do
    it { ExtensionDoc.hashtags['text'].options.must_equal({}) }
    it { ExtensionDoc2.hashtags['text'].options.must_equal(only: [VarTag]) }
  end
end
