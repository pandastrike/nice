class HTML
  constructor: (@options) ->

  _tag: (name,argument) ->

    # when string
    if argument?.substr
      content = argument or ""
      attributes = ""
      
    # when array
    else if argument?.join
      content = argument.join ""
      attributes = ""

    # when object
    else if argument?
      if (content = (argument.content or argument.text))?
        delete argument.content; delete argument.text
      if content?.join
        content = content.join ""
      if argument.url
        argument.href = argument.url ; delete argument.url
      attributes = ("#{key}='#{value}'" for key,value of argument).join " "
      content ?= ""
      
    # default nil
    else
      content = ""; attributes = ""
    
    if content == "" and not name == "script"
      if attributes == ""
        "<#{name}/>"
      else
        "<#{name} #{attributes}/>"
    else
      if attributes == ""
        "<#{name}>#{content}</#{name}>"
      else
        "<#{name} #{attributes}>#{content}</#{name}>"


for tag in "html head title base link meta style script noscript body section nav
  article aside h1 h2 h3 h4 h5 h6 hgroup header footer address p hr pre blockquote 
  ol ul li dl dt dd figure figcaption div a em strong small s cite q dfn abbr data
  time code var samp kbd sub sup i b u mark ruby rp bdi span br wbr ins del img
  iframe embed object param video audio source track canvas map area svg math
  table caption colgroup col tbody thead tfoot tr td th form fieldset legend label
  input button select datalist optgroup option textarea keygen output progress meter
  details summary command menu".split(" ")
  do (tag) ->
    HTML.prototype[tag] = (x) -> @_tag(tag,x)

HTML.beautify = require "./beautify"

module.exports = HTML

