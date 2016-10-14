require 'mongoid'
require 'ostruct'

Mongoid::Fields.option :hashtags do |cls, field, value|
  return if value == false

  cls.define_singleton_method(:hashtags) { @hashtags ||= {} } unless cls.respond_to?(:hashtags)
  options = value.is_a?(Hash) ? value.slice(*%i(only except)) : {}

  cls.hashtags[field.name].define_singleton_method :dom_data do
    Hashtags::Builder.dom_data(options)
  end

  cls.hashtags[field.name].define_singleton_method :help do
    Hashtags::Builder.help(options)
  end

  cls.hashtags[field.name].define_singleton_method :options do
    options
  end

  field.define_singleton_method :demongoize do |*args|
    res = super(*args)
    res.define_singleton_method :to_markup do
      field.type.new(
        Hashtags::Builder.to_markup(res.to_s, options).html_safe
      )
    end
    res.define_singleton_method :to_hashtag do
      field.type.new(
        Hashtags::Builder.to_hashtag(res.to_s, options).html_safe
      )
    end
    res
  end

  field.define_singleton_method :mongoize do |value|
    Hashtags::Builder.to_hashtag(super(value.to_s), options)
  end
end
