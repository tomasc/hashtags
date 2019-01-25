require 'mongoid'
require 'ostruct'

Mongoid::Fields.option :hashtags do |cls, field, value|
  return if value == false
  return if cls.respond_to?(:hashtags)

  cls.define_singleton_method :hashtags do
    options = (value.is_a?(Hash) ? value.slice(*%i(only except)) : {})

    @hashtags ||= {}
    @hashtags[field.name] ||= OpenStruct.new(
      dom_data: Hashtags::Builder.dom_data(options),
      help: Hashtags::Builder.help(options),
      options: options
    )
    @hashtags
  end

  field.define_singleton_method :demongoize do |*args|
    res = super(*args)

    res.define_singleton_method :used_hashtag_classes do
      ho = field.options[:hashtags]
      options = (ho.is_a?(Hash) ? ho.slice(*%i(only except)) : {})
      Hashtags::Builder.used_hashtag_classes(res.to_s, options)
    end

    res.define_singleton_method :to_markup do
      ho = field.options[:hashtags]
      options = (ho.is_a?(Hash) ? ho.slice(*%i(only except)) : {})
      field.type.new(Hashtags::Builder.to_markup(res.to_s, options).html_safe)
    end

    res.define_singleton_method :to_hashtag do
      ho = field.options[:hashtags]
      options = (ho.is_a?(Hash) ? ho.slice(*%i(only except)) : {})
      field.type.new(Hashtags::Builder.to_hashtag(res.to_s, options).html_safe)
    end

    res
  end

  field.define_singleton_method :mongoize do |val|
    ho = field.options[:hashtags]
    options = (ho.is_a?(Hash) ? ho.slice(*%i(only except)) : {})
    Hashtags::Builder.to_hashtag(super(val.to_s), options)
  end
end
