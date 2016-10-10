require 'test_helper'

describe Hashtags::Builder do
  let(:user) { ::User.new('JTschichold', 'Jan Tschichold') }
  let(:user_tag) { "@#{user.id}" }

  let(:res) { ::MyResource.new('123', 'Resource') }
  let(:res_tag) { "#my_resource:#{res.title}(#{res.id})" }

  let(:var_1) { 'A' }
  let(:var_tag) { '$var_1' }

  let(:str) { "User tag: #{user_tag}, resource tag: #{res_tag}, variable tag: #{var_tag}" }

  let(:options) { {} }

  describe '.to_markup' do
    let(:to_markup) do
      user_result = lambda do |id|
        case id
        when user.id then user
        end
      end

      resource_result = lambda do |id|
        case id
        when res.id then res
        end
      end

      ::User.stub(:find, user_result) do
        ::MyResource.stub(:find, resource_result) do
          Hashtags::Builder.to_markup(str, options)
        end
      end
    end

    it { to_markup.must_equal "User tag: #{user.name}, resource tag: #{res.title}, variable tag: #{var_1}" }
  end

  describe 'to_hashtag' do
    let(:to_hashtag) do
      user_result = lambda do |id|
        case id
        when user.id then user
        end
      end

      resource_result = lambda do |id|
        case id
        when res.id then res
        end
      end

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
  end
end
