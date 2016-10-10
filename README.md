# Hashtags

[![Build Status](https://travis-ci.org/tomasc/hashtags.svg)](https://travis-ci.org/tomasc/hashtags) [![Gem Version](https://badge.fury.io/rb/hashtags.svg)](http://badge.fury.io/rb/hashtags) [![Coverage Status](https://img.shields.io/coveralls/tomasc/hashtags.svg)](https://coveralls.io/r/tomasc/hashtags)

Rails engine to facilitate inline text hashtags.

- hashtags are entered inline in text, for example as `@tomasc`, `#location:Home(12345)` or `$my_variable`
- when rendered, they are replaced by actual values, for example HTML tags, images, links etc.

Additionally:

- the user can be assisted with a dropdown triggered by a special character (`#`, `@`, `$`, ...)
- `has_hashtag_field` method is available to assist when rendering HTML input fields incl. data attributes, help, and supporting only specified hashtag classes
- hashtags typically have `cache_key` defined on class so corresponding fragment cache can be easily expired

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hashtags'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install hashtags
```

## Usage

The three following types are included in this gem, however the gem's design allows for definition of new types and their subclassing.

### Hash tag types

#### User hash tag

```
@tomasc
```

#### Resource hash tag

These typically include human-readable version of the resource (in the example below it would be `Home`).

```
#location:Home(12345)
```

#### Variable hash tag

```
$number_of_users
```

### Adding new hash tags in your application

The following are quick examples. It is advised to read the source code of `Hashtags::User`, `Hashtags::Resource` and `Hashtags::Variable` and their superclass `Hashtags::Builder` in order to fully understand the possibilities and flexibility of this gem.

#### User

See `Hashtags::User` and override its methods on your subclass as necessary. Typically it would be at least the following:

```ruby
class UserTag < Hashtags::User
  def self.resource_class
    # User
  end

  def self.tag_attribute
    # name of attribute to be used in the tag
    # @<tag_attribute>
    # for example :username
  end

  def self.result_attribute
    # the tags will be replaced by this attribute
    # for example :full_name
  end

  def self.resources_for_query(query)
    # return JSON representation of resources matching query
    # { label: 'displayed in dropdown', value: 'inserted in the tag', id: … }
    # this will be called from the controller as user types
  end

  def resource(tag_attribute_value)
    # this should find and return resource object
    # self.class.resource_class.find(value)
  end
end
```

Implement the `values` class method instead of the `resources_for_query` to preload values.

#### Resource

See `Hashtags::Resource` and override its methods on your subclass as necessary. Typically it would be at least the following:

```ruby
class LocationTag < Hashtags::Resource
  def self.resource_class
    # Location
  end

  def self.tag_attribute
    # name of attribute to be used in the tag
    # #<tag_attribute>(id)
    # for example :to_s
  end

  def self.result_attribute
    # the tags will be replaced by this attribute
    # for example :to_s
  end

  def self.resources_for_query(query)
    # return JSON representation of resources matching query
    # { label: 'displayed in dropdown', value: 'inserted in the tag', id: … }
    # this will be called from the controller as user types
  end

  def resource(value)
    # this should find and return resource object
    # self.class.resource_class.find(value)
  end
end
```

Implement the `values` class method instead of the `resources_for_query` to preload values.

#### Variable

See `Hashtags::Variable` and override its methods on your subclass as necessary. Typically it would be at least the following:

```ruby
class VariableTag < Hashtags::Resource
  def self.values(hashtag_classes = Hashtags::Variable.descendants)
    # %w(
    #   variable_1
    #   variable_2
    # )
  end

  def markup(match)
    # case name(match)
    # when 'variable_1' then 'foo'
    # when 'variable_2' then 'bar'
    # end
  end
end
```

### Usage in an app

#### Core

```ruby
str = 'Current document: #doc:Foo(123).'
Modulor::HashTag::Builder.to_markup(str) # => 'Current document: Foo.'
```

Since the hashtags might contain human-readable values (as in the `Resource` tags), it is often helpful to update them:

```ruby
doc.title = 'Bar'
Modulor::HashTag::Builder.to_hashtag(str) # => 'Current document: #doc:Bar(123).'
```

Optionally, …

#### With model helpers

#### With JS textcomplete plugin


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/tomasc/hashtags>.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
