lazyLoader = (name) -> get: -> require "./#{name}", enumerable: true

Object.defineProperties module.exports, 
  HTML: lazyLoader "html"
  CSS: lazyLoader "css" 
  Renderer: lazyLoader "renderer"
  Component: lazyLoader "component"