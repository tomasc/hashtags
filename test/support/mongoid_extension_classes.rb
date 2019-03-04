class ExtensionDoc
  include Mongoid::Document
  field :text, type: String, hashtags: true
end

class ExtensionDoc2
  include Mongoid::Document
  field :text, type: String, hashtags: { only: [VarTag] }
end

class ExtensionDoc3
  include Mongoid::Document
  field :f1, type: String, hashtags: { only: [VarTag] }
  field :f2, type: String, hashtags: { only: [VarTag] }
end
