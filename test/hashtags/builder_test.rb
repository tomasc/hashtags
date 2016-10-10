require 'test_helper'

describe Hashtags::Builder do
  let(:user) { ::User.new('JTschichold', 'Jan Tschichold') }
  let(:user_tag) { "@#{user.id}" }

  let(:res) { ::MyResource.new('123', 'Resource') }
  let(:resource_name) { 'my_resource' }
  let(:res_tag) { "##{resource_name}:#{res.title}(#{res.id})" }

  let(:var_1) { 'A' }
  let(:var_tag) { '$var_1' }

  let(:user_result) { lambda { |id| user if user.id == id } }
  let(:resource_result) { lambda { |id| res if res.id == id } }

  let(:str) { "User tag: #{user_tag}, resource tag: #{res_tag}, variable tag: #{var_tag}" }

  let(:options) { {} }

  describe '.to_markup' do
    let(:to_markup) do
      ::User.stub(:find, user_result) do
        ::MyResource.stub(:find, resource_result) do
          Hashtags::Builder.to_markup(str, options)
        end
      end
    end

    it { to_markup.must_equal "User tag: #{user.name}, resource tag: #{res.title}, variable tag: #{var_1}" }

    describe ':only' do
      let(:options) { { only: [VarTag] } }
      it { to_markup.must_equal "User tag: #{user_tag}, resource tag: #{res_tag}, variable tag: #{var_1}" }
    end

    describe ':except' do
      let(:options) { { except: [VarTag] } }
      it { to_markup.must_equal "User tag: #{user.name}, resource tag: #{res.title}, variable tag: #{var_tag}" }
    end
  end

  describe '.to_hashtag' do
    let(:to_hashtag) do
      ::User.stub(:find, user_result) do
        ::MyResource.stub(:find, resource_result) do
          Hashtags::Builder.to_hashtag(str, options)
        end
      end
    end

    before do
      user.id = 'Sunny'
    end

    it { to_hashtag.must_equal "User tag: @Sunny, resource tag: #{res_tag}, variable tag: #{var_tag}" }

    describe ':only' do
      let(:options) { { only: [VarTag] } }
      it { to_hashtag.must_equal "User tag: #{user_tag}, resource tag: #{res_tag}, variable tag: #{var_tag}" }
    end

    describe ':except' do
      let(:options) { { except: [UserTag] } }
      it { to_hashtag.must_equal "User tag: #{user_tag}, resource tag: #{res_tag}, variable tag: #{var_tag}" }
    end
  end

  describe '.dom_data' do
    let(:dom_data) { Hashtags::Builder.dom_data(options) }

    it { dom_data.must_be_kind_of Hash }
    it { dom_data[:hashtags].must_be_kind_of Hash }
    it { dom_data[:hashtags][:path].must_be :present? }
    it { dom_data[:hashtags][:strategies].must_be :present? }
  end

  describe '.help' do
    let(:help) { Hashtags::Builder.help(options) }

    it { help.must_be_kind_of Array }
    it { help.detect { |i| i.hashtag_classes.include? MyResourceTag }.help_values.must_equal [resource_name] }
    it { help.detect { |i| i.hashtag_classes.include? UserTag }.help_values.must_equal %w(user) }
    it { help.detect { |i| i.hashtag_classes.include? VarTag }.help_values.must_equal %w(var_1 var_2) }

    describe ':only' do
      let(:options) { { only: [VarTag] } }
      it { help.map(&:hashtag_classes).wont_include [MyResourceTag] }
      it { help.map(&:hashtag_classes).wont_include [UserTag] }
    end

    describe ':except' do
      let(:options) { { except: [UserTag] } }
      it { help.map(&:hashtag_classes).wont_include UserTag }
    end
  end
end
