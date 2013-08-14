{dashed} = require "fairmont"
{EventChannel} = require "mutual"
EventedData = require "./evented-data"

module.exports = class Gadget
  
  @counter: 0
  
  decorators: null
  
  decorated: false
  
  root: null
  
  container: null
  
  constructor: ({ @class, @name, @events } = {}) ->
    @class ?= dashed @constructor.name
    @name ?= "#{@class}-#{@constructor.counter++}"
    @events ?= new EventChannel
    @html = new @constructor.HTML source: @
    @decorators = []
  
  attach: ( @container ) ->
    @root ?= do @candidate or do @build
    do @decorate
    @container.append(@root)
    @
    
  detach: ->
    do @root?.detach
    @decorated = false
    @
  
  candidate: ->
    candidate = (do @candidates)[0]
    console.log "Gadget candidate for [#{@name}]", candidate
    if candidate? then $(candidate) else null
    
  candidates: ->
    @container?.find(".#{@class}").not("[name]") or []

  build: ->
    do @loading
    $(do @render)
    
  loading: ->
    @load?().once "success", =>
      console.log "Gadget [#{@name}] loaded ..."
      @root = $(do @render)
      @decorated = false
      do @decorate; do @replace
    @

  replace: ->
    console.log "Replacing DOM for Gadget [#{@name}]"
    @container
      ?.find(".#{@class}[name='#{@name}']")
      .replaceWith(@root)
    @
    
  render: (generator) -> 
    console.log "Rendering Gadget [#{@name}]"
    generator ?= => do @html.main
    @html.render(generator)

  decorate: ->
    do @mark
    if @root? and not @decorated
      @decorated = true
      decorator( gadget: @, root: @root ) for decorator in @decorators
    @

  decorator: (fn) -> 
    @decorators.push fn  
    @

  mark: ->
    @root.attr("name", @name)
    @