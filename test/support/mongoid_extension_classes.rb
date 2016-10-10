class ExtensionDoc
  include Mongoid::Document
  field :text, type: String, hashtags: true
end
