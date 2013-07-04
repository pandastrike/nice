{type,delegate} = require "fairmont"
{EventChannel} = require "mutual"

badProperty = (name) -> 
  new Error "EventedData instances can't have a property named '#{name}'"

decorateAsArray = (object) ->
  delegate( object, object._data )
  Object.defineProperty object, "length", 
    get: -> @_data.length
    enumerable: true
    configurable: false
  
module.exports = class EventedData
  
  Object.defineProperty @::, "$data",
    get: -> @_data
    set: (value) -> 
      @_data = value
      futureKeys = Object.keys(value)
      currentKeys = Object.keys(@)
      for key in currentKeys when key.match(/^$/)? and key not in futureKeys
        delete @[key] 
      for key in futureKeys when key not in currentKeys
        @$define( key ) 
      # TODO: Perhaps we should have an EventedArray class or something?
      decorateAsArray(@) if type(@_data) == "array"
      @$events.emit "refresh", value
    enumerable: true
    configurable: false
  
  $on: -> @$events.on( arguments... )
  
  $get: (key) -> 
    [first,rest...] = key.split(".")
    if rest.length == 0
      data = @$data[ key ]
      switch type( data )
        when "object"
          @__wrapped[ key ] ?= 
            new EventedData({ data, events: @$events.source( key ) })
        else data
    else
      if ( child = @$get(first) )?
        child.$get( rest.join(".") )
        
  $set: (key,value) ->
    [first,rest...] = key.split(".")
    if rest.length == 0
      @$data[key] = value
      delete @__wrapped[ key ]
      @$events.emit "#{key}.change", value
      @
    else
      if ( child = @$get(first) )?
        child.$set( rest.join("."), value )
  
  $define: (key) ->
    throw badProperty("constructor") if key == "constructor"
    Object.defineProperty @, key,
      get: -> @$get( key )
      set: (value) -> @$set( key, value )
      enumerable: true
      configurable: false
  
  constructor: ({data, events}) ->
    @__wrapped = {}
    # IMPORTANT: We have to assign events first in case someone is
    # listening for the "refresh" event.
    @$events = if events? then events else (new EventChannel)
    @$data = if data? then data else {}