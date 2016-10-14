class VarTag < Hashtags::Variable
  def self.values(_hashtag_classes = Hashtags::Variable.descendants)
    %w(var_1 var_2)
  end

  def markup(match)
    case name(match)
    when 'var_1' then 'A'
    when 'var_2' then 'B'
    end
  end
end
