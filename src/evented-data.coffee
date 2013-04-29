{type} = require "fairmont"
{EventChannel} = require "mutual"

class EventedObject
  
  constructor: (@data,@events) ->
    @wrapped = {}
    @events ?= new EventChannel
    for key, _ of @data
      do (key) =>
        Object.defineProperty @, key,
          get: -> 
            value = @data[ key ]
            switch type( value )
              when "object"
                @wrapped[ key ] ?= new EventedObject( value, @events.source( key ) )
              else value
          set: (value) ->
            @data[key] = value
            delete @wrapped[ key ]
            @events.fire event: "#{key}.change", content: value
            @
          enumerable: true
          configurable: false


data = new EventedObject
  name: 
    first: "Daniel"
    last: "Yoder"
  email: "danielyoder@gmail.com"
  url: "http://rocket.ly"
  
data.events.on "*.change", (value) ->
  console.log "  Name: #{data.name.first} #{data.name.last}"
  console.log "  Email: #{data.email}"
  console.log "  URL: #{data.url}"
  console.log "-------------------------------"

data.email = "dan@pandastrike.com"
data.url = "http://pandastrike.com"
data.name.first = "Dan"
