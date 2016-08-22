module Hashtags
  class Base < Struct.new(:str)
    def self.default_classes
      Default.descendants
    end

    def self.resource_classes
      Resource.descendants
    end

    def self.variable_classes
      Variable.descendants
    end

    # ---------------------------------------------------------------------

    def self.strategy(hash_tag_classes)
      {
        class_name: to_s,
        match_regexp: json_regexp(match_regexp),
        match_index: match_index,
        match_template: match_template,
        path: path,
        replace: replace,
        template: template,
        values: values(hash_tag_classes)
      }
    end

    # ---------------------------------------------------------------------

    def self.trigger
      raise NotImplementedError
    end

    def self.resource_class
      raise NotImplementedError
    end

    def self.cache_key
      resource_class.cache_key
    end

    # regexp to recognize the complete tag
    def self.regexp
      raise NotImplementedError
    end

    # implement to use custom controller
    def self.path
    end

    # implement to preload hash tag values
    def self.values(_hash_tag_classes)
    end

    # implement to show which values particular trigger offers
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

    # match the user input against this
    def self.match_template
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

    # TODO: replace with serializers

    # return JSON version of resources for specified query
    # this is returned when user starts typing (the query)
    def self.resources_for_query(query)
      resource_class
        .merge(resource_query_criteria(query))
        .map { |resource| resource_as_json(resource) }
    end

    # override on subclass
    def self.resource_query_criteria(_query)
      raise NotImplementedError
    end

    # override on subclass
    def self.resource_as_json(_resource)
      raise NotImplementedError
    end

    # ---------------------------------------------------------------------

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

    # =====================================================================

    # Converts hash tags to markup
    def to_markup
      str.to_s.gsub(self.class.regexp) do |match|
        m = markup(Regexp.last_match)
        match = m || match
      end
    end

    # Updates hash tags
    def to_hash_tag
      str.to_s.gsub(self.class.regexp) do |match|
        ht = hash_tag(Regexp.last_match)
        match = (ht.present? ? ht : match)
      end
    end

    # ---------------------------------------------------------------------

    # the proper hashtag (so it can be updated automatically)
    def hash_tag(_match)
      raise NotImplementedError
    end

    # what is the hashtag replaced with in the end
    def markup(_match)
      raise NotImplementedError
    end
  end
end
