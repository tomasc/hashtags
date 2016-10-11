require 'active_support/core_ext/string/inflections'

module Hashtags
  class Resource < Base
    # implement as resource class in your application
    def self.resource_class
      raise NotImplementedError
    end

    def self.find_by_resource_type(resource_type)
      descendants.detect{ |cls| cls.resource_name.to_s == resource_type.to_s }
    end

    def self.resource_name
      resource_class.to_s.demodulize.underscore
    end

    def self.cache_key
      resource_class.cache_key
    end

    def self.trigger
      '#'
    end

    # name of attribute to be used in the tag
    # #resource_name:<tag_attribute>(id)
    # (for example :to_s)
    def self.tag_attribute
      raise NotImplemented
    end

    # the tags will be replaced by this attribute
    # (for example :link_to)
    def self.result_attribute
      raise NotImplemented
    end

    def self.regexp
      /#{Regexp.escape(trigger)}#{resource_name}:(.+?)\((.+?)\b\)/i
    end

    def self.help_values
      [resource_name]
    end

    # ---------------------------------------------------------------------
    # JS

    def self.match_regexp
      /(#{Regexp.escape(trigger)}#{resource_name}\:)(\w{1,})\z/
    end

    def self.match_index
      2
    end

    def self.match_template
      "{{ #{tag_attribute} }}"
    end

    def self.replace
      "#{trigger}#{resource_name}:{{ #{tag_attribute} }}({{ id }})"
    end

    def self.template
      "{{ #{tag_attribute} }}"
    end

    private # =============================================================

    def hashtag(match)
      return unless id = match[self.class.match_index]
      return unless res = resource(id)
      Handlebars::Context.new
                         .compile(self.class.replace)
                         .call(id: res.id.to_s, self.class.tag_attribute => res.send(self.class.tag_attribute))
    end

    def markup(match)
      return unless id = match[self.class.match_index]
      return unless res = resource(id)
      res.send(self.class.result_attribute)
    end

    # finds resource based on tag_attribute_value
    # (for example resource_class.find(value))
    def resource(value)
      raise NotImplemented
    end
  end
end
