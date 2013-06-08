EventedObject = require "../src/evented-data"
{EventChannel} = require "mutual"

pending = []
later = (fn) -> pending.push fn

events = new EventChannel

data = new EventedObject
  name: 
    first: "Daniel"
    last: "Yoder"
  email: "danielyoder@gmail.com"
  url: "http://rocket.ly",
  events.source("data")

events.on "data.refresh", (data) ->
  console.log "Data is ready!"
  
events.on "*.change", (value) ->
  console.log "  Name: #{data.name.first} #{data.name.last}"
  console.log "  Email: #{data.email}"
  console.log "  URL: #{data.url}"
  console.log "-------------------------------"
  [first,pending...] = pending
  first?()

data.email = "dan@pandastrike.com"
later -> data.url = "http://pandastrike.com"
later -> data.name.first = "Dan"
later -> data.$set("name.last", "Redoy")
later -> console.log data.$get("name.last")
