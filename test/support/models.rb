class Doc
  include Mongoid::Document
  field :text, type: String

  # include Modulor::HashTag::HasField
  # SUPPORTED_hashtagS = [HashTag::Hours, HashTag::Exhibitions, HashTag::Events]
  # has_hashtag_field :body, only: SUPPORTED_hashtagS
end
