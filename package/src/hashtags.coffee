import Handlebars from 'handlebars/dist/handlebars.min.js'
import Textcomplete from 'textcomplete/lib/textcomplete'
import Textarea from 'textcomplete/lib/textarea'

import Plugin from './plugin'

export default class Hashtags extends Plugin
  @defaults =
    name: 'hashtags'
    debug: false

  init: ->
    @editor = new Textarea(@element)
    @textcomplete = new Textcomplete(@editor, dropdown: { className: 'hashtags dropdown-menu textcomplete-dropdown' })
    @textcomplete.register(@get_strategies())

  destroy: ->

  get_data: -> @$element.data 'hashtags'
  get_default_path: -> @get_data()['path']
  get_strategies: -> $.map @get_data()['strategies'], (strategy) => @get_strategy(strategy)
  get_strategy: (data) ->
    {
      index: data.match_index
      cache: true
      context: (text) -> text.toLowerCase()
      match: ///#{data.match_regexp}///
      search: (term, callback, match) =>
        if data.values then @search_values(data, term, callback, match)
        else @search_remote(data, term, callback, match)
      replace: (resource, event) -> Handlebars.compile(data.replace)(resource)
      template: (resource, term) -> Handlebars.compile(data.template)(resource)
    }

  search_values: (data, term, callback, match) ->
    callback $.map( data.values, (value) ->
      if value.match(///^#{term}///i) then value else null
    )

  search_remote: (data, term, callback, match) ->
    url = data.path ? @get_default_path()
    match_template = data.match_template

    $.getJSON( url , q: term, class_name: data.class_name )
      .done( (resp) ->
        callback $.map( resp, (resource) ->
          if Handlebars.compile(match_template)(resource).match(///#{term}///i) then resource else null
        )
      )
      .fail -> callback []
