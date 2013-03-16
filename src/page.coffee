{w} = require "fairmont"

class Page
  
  page: (options={}) ->
    
    {meta,scripts,sheets,body} = options

    meta ?= {}
    meta.charset ?= "utf-8"
    scripts ?= []
    sheets ?= []
    
    
    @doctype()

    @html =>

      @head =>
        for key,value of meta
          @meta name: key, content: value

        for script in scripts
          @script src: script, type: "text/javascript"

        for sheet in sheets
          @link href: sheet, type: "text/css", rel: "stylesheet"

      @body body
    

module.exports = Page