class Renderer

  @include: (mixins...) ->
    for mixin in mixins
      for key, value of mixin::
        @::[key] = value
    @
    
  constructor: (@buffer="") ->
  
  render: (fn) ->
    @buffer = ""
    fn(@)
    result = @buffer
    @buffer = ""
    result
    
  text: (string) -> @buffer += string
  
    
module.exports = Renderer