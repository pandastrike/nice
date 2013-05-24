{include,Property} = require "fairmont"
{EventChannel} = require "mutual"

# Convert title-case to corset-case
convert = (s) -> s.replace(/^([A-Z])/, (c) -> c.toLowerCase()).replace(/([A-Z])/g, (c) -> "-" + c.toLowerCase())

# Convert a class name (ex: ArticleSummary) into a CSS class name ("article-summary")
cname = (self) -> convert( self.constructor.name )

module.exports = class Component
  
  include @, Property
  
  constructor: (@name) ->
    @decorators = []
    @events = new EventChannel
  
  # Find a DOM node within $ to bind to, if possible, otherwise
  # render - useful when you don't know if the content was pre-
  # rendered or not
  activate: (container) ->
    unless @$?
      candidates = container.find( ".#{cname(@)}" ).not( "[name]" )
      if candidates.length > 0
        console.log "BIND", cname(@)
        @bind $(candidates[0])
      else
        console.log "RENDER", cname(@)
        @render container
    else
      container.append @$
    @
    
  # Bind to DOM element in the case where the component is already rendered.
  # This will also ::decorate the associated DOM tree.
  bind: (@$) ->
    @decorate()
    @$.attr("name", @name)
    @

  # Render the HTML, appending to a given dom element. This will also 
  # ::decorate the DOM tree.
  render: (container) ->
    console.log "-- RENDER", cname(@)
    @$ = $( @html )
    @decorate()
    container.append @$
    @
    
  # Add all the event handlers associated with this component.
  decorate: ->
    decorator( @$ ) for decorator in @decorators  
    
  decorator: (fn) ->
    @decorators.push fn

  detach: ->
    @$.detach()
    @
    
  # Get/set the data element, converting to/from EventedData.
  # Should be defined in the descendent classes.
  #  
  # @property data:
  # 
  #   get: ->
  # 
  #   set: (data) ->
  # 
  # Get/set the html property, rendering it anew if necessary.
  # Should be defined in the descendent classes.
  #
  # @property html:  
  # 
  #   get: ->
  # 
  #   set: (data) ->
  #
  
  # Iterate through all the child components, execution an action
  # for each one.
  each: (action) ->
  
  
  
  