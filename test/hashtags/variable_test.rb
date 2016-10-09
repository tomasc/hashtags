require 'test_helper'

describe Hashtags::Variable do
  let(:var_1) { 'A' }
  let(:var_2) { 'B' }

  let(:str) { 'Value of var_1 is $var_1 and value of var_2 is $var_2!' }

  subject { VarTag.new(str) }

  describe '#to_markup' do
    it 'should replace hastags with markup' do
      subject.to_markup.must_equal "Value of var_1 is #{var_1} and value of var_2 is #{var_2}!"
    end
  end
end
