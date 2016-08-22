require 'test_helper'

module Hashtags
  describe Builder do
    # let(:user_1) { Modulor::User.create(email: 'seb@seb.dk', first_name: 'Sebastian', last_name: 'Ly Serena') }
    # let(:user_2) { Modulor::User.create(email: 'asger@asger.dk', first_name: 'Asger', last_name: 'Behncke Jacobsen') }
    let(:str) { "Say hello to @[Sebastian L.](#{user_1.id}) and to @[Asger B.](#{user_2.id})!" }

    # =====================================================================

    describe '.markup' do
      it 'loops via all HashTag classes and applies #to_markup' do
        Builder.new.to_markup(str).must_equal User.new(str).to_markup
      end

      # it 'allows to limit the classes with :only and :except' do
      #   Builder.new(only: []).to_markup(str).wont_equal User.new(str).to_markup
      #   Builder.new(except: [User]).to_markup(str).wont_equal User.new(str).to_markup
      # end
    end

    # describe '.hash_tag' do
    #   it 'loops via all HashTag classes and applies #to_hash_tag' do
    #     Builder.new.to_hash_tag(str).must_equal User.new(str).to_hash_tag
    #   end
    #
    #   it 'allows to limit the classes with :only and :except' do
    #     Builder.new(only: []).to_hash_tag(str).wont_equal User.new(str).to_hash_tag
    #     Builder.new(except: [User]).to_hash_tag(str).wont_equal User.new(str).to_hash_tag
    #   end
    # end
    #
    # describe 'help' do
    #   let(:help) { Builder.new(only: [User, Page]).help }
    #
    #   it 'returns OpenStruct objects with triggers & values' do
    #     help.map(&:class).uniq.must_equal [OpenStruct]
    #     help.map(&:trigger).must_equal %w(@ #)
    #     help.map(&:help_values).flatten.must_equal %w(user page)
    #   end
    # end
  end
end
