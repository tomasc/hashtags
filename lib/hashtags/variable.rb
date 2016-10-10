module Hashtags
  class Variable < Base
    def self.trigger
      '$'
    end

    def self.regexp
      /#{Regexp.escape(trigger)}(.+?)\b/i
    end

    def self.values(hashtag_classes = Variable.descendants)
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

    def self.replace
      "#{trigger}1{{ this }}"
    end

    def self.template
      '{{ this }}'
    end

    def self.strategy(hashtag_classes)
      super.tap { |obj| obj[:values] = compound_values(hashtag_classes) }
    end

    def self.compound_values(hashtag_classes)
      cls = Builder.new.filter_classes(variable_classes & hashtag_classes)
      cls.map { |i| i.values(hashtag_classes) }.flatten.compact
    end

    private # =============================================================

    def hashtag(match)
      return unless name(match)
      [self.class.trigger, name(match)].join
    end

    def name(match)
      return unless self.class.values.include?(match[1])
      match[1]
    end
  end
end
