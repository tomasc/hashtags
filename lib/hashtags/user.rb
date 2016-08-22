require 'handlebars'

class Hashtags
  class User < Default
    def self.resource_class
      Modulor::User
    end

    def self.resource_name
      resource_class.to_s.demodulize.underscore
    end

    # ---------------------------------------------------------------------

    def self.trigger
      '@'
    end

    def self.regexp
      /#{Regexp.escape(trigger)}(.+?)\((.+?)\b\)/i
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
      2
    end

    def self.match_template
      '{{ human_id }}'
    end

    def self.replace
      '$1{{ human_id }}({{ _id }})'
    end

    def self.template
      '{{ human_id }}'
    end

    # ---------------------------------------------------------------------

    def self.resource_query_criteria(_query)
      resource_class.where(human_id: /\A#{query}/i)
    end

    def self.resource_as_json(resource)
      { _id: resource.id.to_s, to_s: resource.to_s, human_id: resource.human_id }
    end

    private # =============================================================

    def hash_tag(match)
      return unless id = match[2]
      return unless user = resource(id)
      # FIXME: not so nice with the $1
      Handlebars::Context.new
                         .compile(self.class.replace.gsub('$1', Regexp.escape(self.class.trigger)))
                         .call(human_id: user.human_id, _id: user.id.to_s)
    end

    def markup(match)
      return unless id = match[2]
      return unless user = resource(id)
      user.to_s
    end

    # ---------------------------------------------------------------------

    # FIXME: too specific
    def resource(id)
      return unless BSON::ObjectId.legal?(id)
      Modulor::User.where(_id: BSON::ObjectId.from_string(id)).first
    end
  end
end
