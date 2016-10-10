require 'handlebars'

module Hashtags
  class User < Base
    # implement as user class in your application
    def self.resource_class
      raise NotImplemented
    end

    def self.resource_name
      resource_class.to_s.demodulize.underscore
    end

    # override for custom cache_key
    def self.cache_key
      resource_class.cache_key
    end

    def self.trigger
      '@'
    end

    # name of attribute to be used in the tag
    # @<tag_attribute> (for example :username)
    def self.tag_attribute
      raise NotImplemented
    end

    # the tags will be replaced by this attribute
    # (for example :full_name)
    def self.result_attribute
      raise NotImplemented
    end

    def self.regexp
      /#{Regexp.escape(trigger)}(\w+)/i
    end

    def self.help_values
      [resource_name]
    end

    # ---------------------------------------------------------------------
    # JS

    def self.match_regexp
      /(\A#{trigger}|\s#{trigger})(\w{1,})\z/
    end

    def self.match_index
      1
    end

    def self.match_template
      "{{ #{tag_attribute} }}"
    end

    def self.replace
      "$1{{ #{tag_attribute} }}"
    end

    def self.template
      "{{ #{tag_attribute} }}"
    end

    private # =============================================================

    # updates found tags with tag value from resource
    # @jtschichold => @JTschichold
    def hashtag(match)
      return unless id = match[self.class.match_index]
      return unless user = resource(id)
      Handlebars::Context.new
                         .compile(self.class.replace.gsub('$1', Regexp.escape(self.class.trigger)))
                         .call(self.class.tag_attribute => user.send(self.class.tag_attribute))
    end

    # replaces tags with result from resource
    # @JTschichold => Jan Tschichold
    def markup(match)
      return unless id = match[self.class.match_index]
      return unless user = resource(id)
      user.send(self.class.result_attribute)
    end

    # finds resource based on tag_attribute_value
    # for example: resource_class.where(username: tag_attribute_value).first
    def resource(tag_attribute_value)
      raise NotImplemented
    end
  end
end
