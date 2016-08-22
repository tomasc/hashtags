module Hashtags
  class Resource < Base
    def self.resource_class
      raise NotImplementedError
    end

    def self.resource_name
      resource_class.to_s.demodulize.underscore
    end

    def self.trigger
      '#'
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
      '{{ human_id }}'
    end

    def self.replace
      "#{trigger}#{resource_name}:{{ human_id }}({{ _id }})"
    end

    def self.template
      '{{ human_id }}'
    end

    # ---------------------------------------------------------------------

    # override on subclass
    def self.resource_query_criteria(query)
      resource_class.where(unique_id: /\A#{query}/i)
    end

    # override on subclass
    def self.resource_as_json(resource)
      { _id: resource.id.to_s, to_s: resource.to_s, human_id: resource.unique_id }
    end

    private # =============================================================

    def hash_tag(match)
      return unless id = match[2]
      return unless res = resource(id)
      Handlebars::Context.new
                         .compile(self.class.replace)
                         .call(human_id: res.unique_id, _id: res.id.to_s)
    end

    def markup(match)
      return unless id = match[2]
      return unless res = resource(id)
      res.to_s
    end

    # ---------------------------------------------------------------------

    # FIXME: too specific!
    def resource(id)
      return unless BSON::ObjectId.legal?(id)
      @resource ||= {}
      @resource[id] ||= self.class.resource_class.where(_id: BSON::ObjectId.from_string(id)).first
    end
  end
end
