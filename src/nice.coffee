lazyLoader = (name) -> get: -> require "./#{name}", enumerable: true

Object.defineProperties module.exports, 
  HTML: lazyLoader "html"
  CSS: lazyLoader "css" 
  Page: lazyLoader "page"
  Renderer: lazyLoader "renderer"
  Component: lazyLoader "component"