module.exports =
  
  grid: (measure) ->
    "#{measure}rem"
    
  # @rule "html *", =>
  #   @boxSizing "border-box"
  # 
  # @rule "body", =>
  #   @width "72rem"
  #   @margin "auto"
  #   
  # @rule ".row", =>
  #   @width "100%"
  # 
  # @rule ".cell", =>
  #   @padding "1rem"
  #   @display "inline-block"
  #   @verticalAlign "top"
  # 
  # @rule ".centered", =>
  #   @textAlign "center"
  # 
  # @rule ".right", =>
  #   @textAlign "right"
  # 
  # @rule ".flush.row  > .cell", =>
  #   @padding "0 1rem"
  # 
  # @block =>  
  #   
  #   for width in [1..12]
  #     
  #     @rule ".width-#{width}", =>
  #       @width "#{6 * width}rem"
  #     
  #     # basically, once we are past the first level of nesting
  #     # everything becomes fluid
  #     @rule ".row .row .width-#{width}", =>
  #       @width( @percent( width/12 ) )
  