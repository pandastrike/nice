beautify = require "./beautify"

class Pages
  
  constructor: (options) ->
    @_javascript = options.javascript
    @_css = options.css
  
  page: (options) ->
    {javascript,css,body,meta} = options

    beautify @doctype() + @html.html [
    
      @html.head [
        @meta(meta)
        @javascript(javascript)
        @css(css)
      ]
    
      @html.body body
    ]
    
  doctype: -> "<!DOCTYPE html>" 

  meta: -> ""

  javascript: (scripts) ->
    (for script in scripts.split(" ")
      @html.script
        src: @_javascript[script]
        type: "text/javascript").join " "

  css: (stylesheets) ->
    (for stylesheet in stylesheets.split(" ")
      @html.link
        href: @_css[stylesheet]
        type: "text/css"
        rel: "stylesheet").join ""

  
module.exports = Pages