{type} = require "fairmont"
{EventChannel} = require "mutual"

badProperty = (name) -> 
  new Error "EventedData instances can't have a property named '#{name}'"

module.exports = class EventedData
  
  Object.defineProperty @::, "$data",
    get: -> @_data
    set: (value) -> 
      @_data = value
      @$events.emit "refresh", value
    enumerable: true
    configurable: false
  
  $on: -> @$events.on( arguments... )
  
  $get: (key) -> 
    [first,rest...] = key.split(".")
    if rest.length == 0
      value = @$data[ key ]
      switch type( value )
        when "object"
          @__wrapped[ key ] ?= 
            new EventedData( value, @$events.source( key ) )
        else value
    else
      if ( child = @$get(first) )?
        child.$get( rest.join("."), value )
        
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
  
  constructor: (data,events) ->
    @__wrapped = {}
    # IMPORTANT: We have to assign events first in case someone is
    # listening for the "refresh" event.
    @$events = events
    @$data = data
    @$events ?= new EventChannel
    @$define( key ) for key, _ of @$data
