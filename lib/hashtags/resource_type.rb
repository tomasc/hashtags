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
      /(\A#{trigger}|\s#{trigger})(\w*)\z/
    end

    def self.match_index
      2
    end

    def self.match_template
      # not needed here
    end

    def self.replace
      '$1{{ this }}:'
    end

    def self.template
      '{{ this }}'
    end

    # ---------------------------------------------------------------------

    def self.values(hash_tag_classes)
      (resource_classes & hash_tag_classes).map(&:resource_name)
    end

    def self.cache_key
      resource_classes.count
    end

    private # =============================================================

    def hash_tag(match)
      # do nothing
    end

    def markup(match)
      # do nothing
    end
  end
end
