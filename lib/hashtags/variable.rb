module Hashtags
  class Variable < Base
    def self.trigger
      '$'
    end

    def self.regexp
      /#{Regexp.escape(trigger)}(.+?)\b/i
    end

    def self.resource_class
    end

    def self.values(_hash_tag_classes = self.class.descendants)
      raise NotImplemented
    end

    def self.help_values
      values
    end

    # ---------------------------------------------------------------------
    # JS

    def self.match_regexp
      /(\A#{Regexp.escape(trigger)}|\s#{Regexp.escape(trigger)})(\w*)\z/
    end

    def self.match_index
      2
    end

    def self.match_template
      # not needed here
    end

    def self.replace
      "#{trigger}1{{ this }}"
    end

    def self.template
      '{{ this }}'
    end

    def self.strategy(hash_tag_classes)
      super.tap do |obj|
        obj[:values] = compound_values(hash_tag_classes)
      end
    end

    def self.compound_values(hash_tag_classes)
      cls = Builder.new.filter_classes(variable_classes & hash_tag_classes)
      cls.map { |i| i.values(hash_tag_classes) }.flatten.compact
    end

    # ---------------------------------------------------------------------

    def self.resource_query_criteria
    end

    def self.resource_as_json(_resource)
    end

    private # =============================================================

    def hash_tag(match)
      return unless name(match)
      [self.class.trigger, name(match)].join
    end

    def name(match)
      return unless self.class.values.include?(match[1])
      match[1]
    end
  end
end
