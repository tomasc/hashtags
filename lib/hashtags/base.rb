module Hashtags
  # Base class, from which all Hashtag types inherit
  # In case you wish to add a new type next to
  # • ResourceType
  # • Resource
  # • User
  # • Variable
  # you might want to inherit from Base.

  class Base < Struct.new(:str)
    def self.to_markup(str)
      new(str).to_markup
    end

    def self.to_hashtag(str)
      new(str).to_hashtag
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.resource_classes
      Resource.descendants
    end

    def self.user_classes
      User.descendants
    end

    def self.variable_classes
      Variable.descendants
    end

    # to be passed to textcomplete
    def self.strategy(hashtag_classes)
      {
        class_name: to_s,
        match_regexp: json_regexp(match_regexp),
        match_index: match_index,
        match_template: match_template,
        path: path,
        replace: replace,
        template: template,
        values: values(hashtag_classes)
      }
    end

    # for example @ # $ …
    def self.trigger
      raise NotImplementedError
    end

    # matched against as user types
    # typically this would equal to the .template (match what you see)
    def self.match_template
      template
    end

    # used to expire field with tags
    def self.cache_key
      raise NotImplementedError
    end

    # regexp to recognize the complete tag
    def self.regexp
      raise NotImplementedError
    end

    # implement to use custom controller
    def self.path
    end

    # implement to preload hash tag values,
    # fe in case there is limited number (ie variable names)
    def self.values(hashtag_classes)
    end

    # implement to show which values particular trigger offers
    # fe # -> lists all available resource types
    def self.help_values
    end

    # ---------------------------------------------------------------------
    # JS

    # trigger dropdown when user input matches this regexp
    def self.match_regexp
      raise NotImplementedError
    end

    # index of the match group from the above regexp to be used for matching
    def self.match_index
      raise NotImplementedError
    end

    # tag that gets inserted into the field
    def self.replace
      raise NotImplementedError
    end

    # fragment to be displayed in the dropdown menu
    def self.template
      raise NotImplementedError
    end

    # ---------------------------------------------------------------------

    # return JSON version of resources that match query
    # this is returned when user starts typing (the query)
    def self.json_for_query(query)
      raise NotImplementedError
    end

    def self.values(hashtag_classes = Variable.descendants)
    end

    # ---------------------------------------------------------------------

    # converts Ruby tegexp to JS regexp
    def self.json_regexp(regexp)
      str = regexp.inspect
                  .sub('\\A', '^')
                  .sub('\\Z', '$')
                  .sub('\\z', '$')
                  .sub(/^\//, '')
                  .sub(/\/[a-z]*$/, '')
                  .gsub(/\(\?#.+\)/, '')
                  .gsub(/\(\?-\w+:/, '(')
                  .gsub(/\s/, '')
      Regexp.new(str).source
    end

    # ---------------------------------------------------------------------

    # Converts hash tags to markup
    def to_markup
      str.to_s.gsub(self.class.regexp) do |match|
        m = markup(Regexp.last_match)
        match = m || match
      end
    end

    # Updates hash tags
    def to_hashtag
      str.to_s.gsub(self.class.regexp) do |match|
        ht = hashtag(Regexp.last_match)
        match = ht || match
      end
    end

    # ---------------------------------------------------------------------

    # the proper hashtag (so it can be updated automatically)
    def hashtag(match)
      raise NotImplementedError
    end

    # what is the hashtag replaced with in the end
    def markup(match)
      raise NotImplementedError
    end
  end
end
