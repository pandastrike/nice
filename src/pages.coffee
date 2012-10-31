{w} = require "fairmont"

class Pages
  
  constructor: (options) ->
    {@html,@resources} = options
      
  page: (options) ->
    
    {meta,javascript,css,body} = options

    @html.doctype()
    @html.html =>
      @html.head =>
        @meta meta
        @javascript javascript
        @css css
      @html.body body
    
  meta: -> ""

  javascript: (scripts) ->
    for script in w scripts
      @html.script
        src: @resources.javascript[script]
        type: "text/javascript"

  css: (stylesheets) ->
    for stylesheet in w stylesheets
      @html.link
        href: @resources.css[stylesheet]
        type: "text/css"
        rel: "stylesheet"

  
module.exports = Pages