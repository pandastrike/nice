{w,type} = require "fairmont"
beautify = require "./beautify"

class HTML
  
  text: (string) -> @buffer += string
  
  doctype: -> @text "<!DOCTYPE html>" 

  _tag: (name,_void,args...) ->

    content = null
    generator = null
    attributes = {}
    
    for arg in args
      switch type arg
        when "function"
          generator = arg
        when "string","number", "boolean"
          content = arg
        when "object"
          attributes = arg
          
    attributes = (for key,value of attributes
      value = value.join(" ").trim() if type(value) is "array"
      "#{key}='#{value}'" if value? and value!="").join(" ").trim()
      
    @text "<#{name}"
    @text " #{attributes}" unless attributes == ""
    if generator? or content? or not _void
      @text ">"
      @text content if content?
      generator() if generator?
      @text "</#{name}>"
    else
      @text "/>"
      
    @buffer
    
  beautify: (fn) ->
    fn()
    # TODO: Figure out a way for mixins to have 
    # options. One possibility is to just to have a
    # shared options object that each mixin looks 
    # at for it's options, but that feels wrong.
    @buffer = beautify @buffer,
      indent_size: 2
      indent_char: ' '
      max_char: 78

for tag in w "html head title style script noscript body section nav
  article aside h1 h2 h3 h4 h5 h6 hgroup header footer address p pre blockquote 
  ol ul li dl dt dd figure figcaption div a em strong small s cite q dfn abbr data
  time code var samp kbd sub sup i b u mark ruby rp bdi span ins del
  iframe object video audio canvas map area svg math
  table caption colgroup tbody thead tfoot tr td th form fieldset legend label
  button select datalist optgroup option textarea output progress meter
  details summary menu"
  do (tag) ->
    HTML.prototype[tag] = (args...) -> @_tag(tag,false,args...)

 # Valid self-closing HTML 5 elements.
for tag in w "area base br col command embed hr img input keygen link meta param
  source track wbr"
  do (tag) ->
    HTML::[tag] = (args...) -> @_tag(tag,true,args...)

module.exports = HTML