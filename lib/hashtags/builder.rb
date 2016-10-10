module Hashtags
  class Builder < Struct.new(:options)
    def self.to_markup(str, options = {})
      new(options).to_markup(str)
    end

    def self.to_hashtag(str, options = {})
      new(options).to_hashtag(str)
    end

    def self.dom_data(options = {})
      new(options).dom_data
    end

    def self.help(options = {})
      new(options).help
    end

    def initialize(options = {})
      super(options)
    end

    # collects markup from all hashtags classes
    def to_markup(str)
      hashtag_classes.inject(str) { |res, cls| cls.to_markup(res) }
    end

    # collects hashtags from all hashtags classes
    def to_hashtag(str)
      hashtag_classes.inject(str) { |res, cls| cls.to_hashtag(res) }
    end

    # render textcomplete dom data
    def dom_data
      { hashtags: {
        path: Engine.routes.url_helpers.resources_path,
        strategies: hashtag_strategies
      } }
    end

    # render help string
    def help
      hashtag_classes.group_by(&:trigger).map do |trigger, cls|
        OpenStruct.new(hashtag_class: cls, trigger: trigger, help_values: cls.map(&:help_values).flatten.compact.sort)
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

    def hashtag_classes
      filter_classes(
        Resource.resource_classes +
        User.user_classes +
        Variable.variable_classes
      )
    end

    def hashtag_strategies
      cls = hashtag_classes.dup

      # add resource type strategy if needed
      cls << ResourceType if cls.any? { |c| c < Resource } && !cls.include?(ResourceType)

      # remove all variable classes and replace them with one strategy
      if variable_cls = cls.select { |c| c < Variable } && variable_cls.present?
        cls -= variable_cls
        cls << Variable
      end

      cls.collect { |c| c.strategy(hashtag_classes) }
    end
  end
end
