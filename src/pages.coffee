beautify = require "./beautify"

# TODO: This is a bit confused, since we
# are requiring a great deal of classes
# that mix us in. First, we effectively
# require you to mixin with your main
# class, since we assume an @html
# attribute. Second, we expect
# @javascript_files and @css_files to be
# defined at that same level.
# 
# If this were a stand-alone class, it
# could simply take the HTML generator in
# the constructor, along with the hashes
# for Javascript and CSS files.

Pages =
  
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
        src: @javascript_files[script]
        type: "text/javascript").join " "

  css: (stylesheets) ->
    (for stylesheet in stylesheets.split(" ")
      @html.link
        href: @css_files[stylesheet]
        type: "text/css"
        rel: "stylesheet").join ""

  
module.exports = Pages