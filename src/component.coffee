{w,type} = require "fairmont"

class Composer

  @include: (mixins...) ->
    for mixin in mixins
      for key, value of mixin::
        @::[key] = value
    @

  constructor: (@root={}) ->

  render: (fn) ->
    @root = {}
    fn(@)
    result = @root
    @root = {}
    result

  _tag: (name,label,options,fn) ->
    @root[label] =
      _parent: @root
      _root: (if @root._root? then @root._root else @root)
      _attributes: options
    @root = @root[label]
    fn?()
    @root = @root._parent
    

for tag in w "page panel header footer article sidebar search ads aboutMe popular"
  do (tag) ->
    Composer::[tag] = (args...) ->
      label = tag
      options = {}
      fn = null
      for arg in args
        switch type( arg )
          when "string" then label = arg
          when "object" then options = arg
          when "function" then fn = arg
      @_tag( tag, label, options, fn )


class App extends Composer
  main: ->
    @page title: "My Blog", =>
      @panel orient: "vertically", =>
        @header title: "My Blog"
        @panel "content", orient: "horizontally", =>
          @article title: "My Post"
          @sidebar =>
            @search()
            @ads()
            @aboutMe()
            @popular()
        @footer()
              
              
app = new App
root = app.render -> app.main()
console.log root.page.panel.content.sidebar

            
            