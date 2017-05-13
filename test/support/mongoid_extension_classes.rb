class ExtensionDoc
  include Mongoid::Document
  field :text, type: String, hashtags: true
end

class ExtensionDoc2
  include Mongoid::Document
  field :text, type: String, hashtags: { only: [VarTag] }
end
