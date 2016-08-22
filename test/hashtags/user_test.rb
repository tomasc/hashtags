# require 'test_helper'
#
# describe Modulor::HashTag::User do
#   let(:user_1) { Modulor::User.create(email: 'seb@seb.dk', first_name: 'Sebastian', last_name: 'Ly Serena') }
#   let(:user_2) { Modulor::User.create(email: 'asger@asger.dk', first_name: 'Asger', last_name: 'Behncke Jacobsen') }
#   let(:str) { "Say hello to @SebastianL(#{user_1.id}) and to @AsgerB(#{user_2.id})!" }
#   let(:user_1_result) { "Sebastian L." }
#   let(:user_2_result) { "Asger B." }
#   subject { Modulor::HashTag::User.new(str) }
#
#   # =====================================================================
#
#   describe 'args' do
#     it { subject.must_respond_to :str }
#   end
#
#   # ---------------------------------------------------------------------
#
#   describe '.cache_key' do
#     it { subject.class.cache_key.must_equal Modulor::User.cache_key }
#   end
#
#   # ---------------------------------------------------------------------
#
#   describe '#regexp' do
#     it { subject.class.regexp.must_be_kind_of Regexp }
#   end
#
#   describe '#to_markup' do
#     it 'should replace hastags with markup' do
#       subject.to_markup.must_equal "Say hello to #{user_1_result} and to #{user_2_result}!"
#     end
#
#     it 'should not do anything when user not found' do
#       subject.str = "Say hello to @SebastianL(123456789) and to @AsgerB(#{user_2.id})!"
#       subject.to_markup.must_equal "Say hello to @SebastianL(123456789) and to #{user_2_result}!"
#     end
#   end
#
#   describe '#to_hash_tag' do
#     it 'updates the original str with new values' do
#       user_1.update_attributes(first_name: 'Sunny')
#       subject.to_hash_tag.must_equal "Say hello to @SunnyL(#{user_1.id}) and to @AsgerB(#{user_2.id})!"
#     end
#   end
# end
