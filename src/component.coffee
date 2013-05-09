{include,Property} = require "fairmont"

module.exports = class Component
  
  include @, Property
  
  # Bind to DOM element in the case where the component is already rendered.
  # This will also ::decorate the associated DOM tree.
  bind: (@$) ->
    @decorate()

  # Render the HTML, appending to a given dom element. This will also 
  # ::decorate the DOM tree.
  render: (dom) ->
    @$ = $( @html )
    @decorate()
    dom.html @$
    
  # Add all the event handlers associated with this component.
  decorate: ->
    

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
  
  
  
  