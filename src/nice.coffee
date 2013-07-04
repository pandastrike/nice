modules = 
  HTML: "html"
  CSS: "css"
  Renderer: "renderer"
  Gadget: "gadget"
  DataGadget: "data-gadget"
  EventedData: "evented-data"

for pname, mname of modules
  do (pname,mname) ->
    Object.defineProperty module.exports, pname, 
      get: -> require "./#{mname}"
      enumerable: true
