{w} = require "fairmont"

class Page
  
  page: (options={}) ->
    
    {meta,scripts,sheets,body} = options

    meta ?= []
    scripts ?= []
    sheets ?= []
    
    
    @doctype()

    @html =>

      @head =>
        
        for _meta in meta
          @meta _meta

        for script in scripts
          @script src: script, type: "text/javascript"

        for sheet in sheets
          @link href: sheet, type: "text/css", rel: "stylesheet"

      @body body
    

module.exports = Page