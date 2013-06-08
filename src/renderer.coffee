class Renderer

  constructor: (@buffer="") ->
  
  render: (fn) ->
    @buffer = ""
    fn(@)
    result = @buffer
    @buffer = ""
    result
    
  text: (string) -> @buffer += string
  
    
module.exports = Renderer