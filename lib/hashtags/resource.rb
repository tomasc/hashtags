require 'active_support/core_ext/string/inflections'

module Hashtags
  class Resource < Base
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.resource_class
      raise NotImplementedError
    end

    def self.resource_name
      resource_class.to_s.demodulize.underscore
    end

    def self.trigger
      '#'
    end

    # name of attribute to be used in the tag
    # #<tag_attribute>(id)
    def self.tag_attribute
      raise NotImplemented
    end

    # the tags will be replaced by this attribute
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
      /(#{trigger}#{resource_name}\:)(\w*)\z/
    end

    def self.match_index
      2
    end

    def self.match_template
      "{{ #{tag_attribute} }}"
    end

    def self.replace
      "#{trigger}#{resource_name}:{{ tag_attribute }}({{ id }})"
    end

    def self.template
      "{{ #{tag_attribute} }}"
    end

    # option – what is displayed in the dropdown
    # tag – inserted into the tag
    def self.resource_as_json(resource)
      { option: resource.send(result_attribute), tag: resource.send(tag_attribute), id: resource.id }
    end

    private # =============================================================

    def hash_tag(match)
      return unless id = match[self.class.match_index]
      return unless res = resource(id)
      Handlebars::Context.new
                         .compile(self.class.replace)
                         .call(id: res.id.to_s, self.class.tag_attribute => resource.send(self.class.tag_attribute))
    end

    def markup(match)
      return unless id = match[self.class.match_index]
      return unless res = resource(id)
      res.send(self.class.result_attribute)
    end

    # finds resource based on tag_attribute_value
    def resource(tag_attribute_value)
      raise NotImplemented
    end
  end
end
