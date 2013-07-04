Gadget = require "./gadget"

module exports = class DataGadget extends Gadget
  
  constructor: ({ data }) ->
    @_data = new EventedData({ data, events: @events.source( "data" ) })
    @html ?= new @constructor.HTML({ @data })
    @events.on "data.refresh", => do @render
    
  @property data:
    get: -> @_data
    set: (data) -> @_data.$data = data

  # TODO: this is super-simplistic right now. we should handle
  # more data types and allow for custom render functions, too.
  decorate: ->
    super
  
    # map all the named DOM elements to the @data property
    for el in @root.find("[name]")
      do (el=$(el)) =>

        el.prop("disabled", true)

        name = el.attr("name")

        type = el.data("type")
        type ?= "string"   
        switch type

          when "string"
            update = (value) -> 
              if el.prop("tagName") in ["INPUT","TEXTAREA"]
                switch el.prop("type")
                  when "checkbox"
                    el.prop("checked", value )
                  else
                    el.val( value ) if el.val() != value
              else
                el.text( value )
            @events.on "data.refresh", => 
              el.prop( "disabled",false )
              update( @data.$get( name ) )
            @events.on "data.#{name}.change", update
            el.change => 
              switch el.prop("type")
                when "checkbox"
                  @data.$set( name, el.prop("checked") )
                else
                  @data.$set( name, el.val()  )
              false

          when "array"
            update = (value) -> 
              if el.prop("tagName") in ["INPUT","TEXTAREA"]
                el.val( value ) if el.val() != value
              else
                el.text( value )
            @events.on "data.refresh", => 
              el.prop( "disabled",false )
              update( @data.$get( name ).join(", ") )
            @events.on "data.#{name}.change", update
            el.change => 
              value = el.val().split(",")
              value = (item.trim() for item in value)
              @data.$set( name, value )
              false
