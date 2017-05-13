require 'active_support/descendants_tracker'

module Hashtags
  class ResourceType < Base
    def self.trigger
      '#'
    end

    def self.regexp
      /#{trigger}(.+?)\b/i
    end

    def self.resource_classes
      Resource.descendants
    end

    # ---------------------------------------------------------------------
    # JS

    def self.match_regexp
      /(#{trigger})(\w*)\z/
    end

    def self.match_index
      2
    end

    def self.replace
      '$1{{ this }}:'
    end

    def self.template
      '{{ this }}'
    end

    # ---------------------------------------------------------------------

    def self.values(hashtag_classes = Resource.descendants)
      (resource_classes & hashtag_classes).map(&:resource_name)
    end

    def self.cache_key
      resource_classes.map(&:resource_name)
    end

    private # =============================================================

    def hashtag(match)
      # do nothing
    end

    def markup(match)
      # do nothing
    end
  end
end
