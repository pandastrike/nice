EventedData = require "../src/evented-data"
{EventChannel} = require "mutual"

pending = []
later = (fn) -> pending.push fn
next = -> 
  [first,pending...] = pending
  first?()

events = new EventChannel

data = new EventedData
  data:
    name: 
      first: "Daniel"
      last: null
    email: "danielyoder@gmail.com"
    url: "http://rocket.ly"
  events: events.source("data")

events.on "data.refresh", (data) ->
  console.log "  Data is ready!"
  console.log "-------------------------------"
  do next
  
events.on "*.change", (value) ->
  console.log "  Name: #{data.name.first} #{data.name.last}"
  console.log "  Email: #{data.email}"
  console.log "  URL: #{data.url}"
  console.log "-------------------------------"
  do next
  
later -> data.email = "dan@pandastrike.com"
later -> data.url = "http://pandastrike.com"
later -> data.name.first = "Dan"
later -> data.$set("name.last", "Yoder")
later -> 
  console.log "  [name.last]:", data.$get("name.last")
  console.log "-------------------------------"

