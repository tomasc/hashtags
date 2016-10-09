module Hashtags
  class Builder < Struct.new(:options)
    def initialize(options = {})
      super(options)
    end

    # collects markup from all hashtags classes
    def to_markup(str)
      hash_tag_classes.inject(str) { |res, cls| cls.new(res).to_markup }
    end

    # collects hashtags from all hashtags classes
    def to_hash_tag(str)
      hash_tag_classes.inject(str) { |res, cls| cls.new(res).to_hash_tag }
    end

    # render textcomplete dom data
    def dom_data
      {
        hash_tag_path: Engine.routes.url_helpers.hashtags_path,
        hash_tag_strategies: hash_tag_strategies
      }
    end

    # render help string
    def help
      hash_tag_classes.group_by(&:trigger).map do |trigger, cls|
        OpenStruct.new(trigger: trigger, help_values: cls.map(&:help_values).flatten.compact.sort)
      end
    end

    def filter_classes(cls)
      return [] unless cls.present?
      res = cls
      res &= options[:only] if options[:only]
      res -= options[:except] if options[:except]
      res
    end

    private

    def hash_tag_classes
      filter_classes(
        Hashtags.resource_classes +
        Hashtags.user_classes +
        Hashtags.variable_classes
      )
    end

    def hash_tag_strategies
      cls = hash_tag_classes.dup

      # add resource type strategy if needed
      cls << ResourceType if cls.any? { |c| c < Resource } && !cls.include?(ResourceType)

      # remove all variable classes and replace them with one strategy
      if variable_cls = cls.select { |c| c < Variable } && variable_cls.present?
        cls -= variable_cls
        cls << Variable
      end

      cls.collect { |c| c.strategy(hash_tag_classes) }
    end
  end
end
