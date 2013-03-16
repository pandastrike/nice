class Renderer
  
  constructor: (@buffer="") ->
  
  render: (fn) ->
    @buffer = ""
    fn()
    result = @buffer
    @buffer = ""
    result
    
  @include: (mixins...) ->
    for mixin in mixins
      for key, value of mixin::
        @::[key] = value
    @
    
module.exports = Renderer