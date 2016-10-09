require 'test_helper'

class VarTag < Hashtags::Variable
  def self.values(hash_tag_classes = Hashtags::Variable.descendants)
    %w(var_1 var_2)
  end

  def markup(match)
    case name(match)
    when 'var_1' then 'A'
    when 'var_2' then 'B'
    end
  end
end

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
