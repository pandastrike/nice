modules = 
  HTML: "html"
  CSS: "css"
  Renderer: "renderer"
  Component: "component"
  EventedData: "evented-data"

for pname, mname of modules
  do (pname,mname) ->
    Object.defineProperty module.exports, pname, 
      get: -> require "./#{mname}"
      enumerable: true
