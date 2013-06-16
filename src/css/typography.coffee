module.exports = ->
  
  @mixins.main.rhythm = (proportion, block) =>
    block (size) =>
      height = Math.ceil( size )
      size = ( height * ( 1 / proportion ) )
      @fontSize @cssNumber( size, "rem" )
      @lineHeight "#{height}rem"

  @mixins.main.scale = (factor) =>
    @rule "html", =>
      percentage = factor * 100
      @fontSize @number( percentage, "%" )
      @lineHeight "1"

  @mixins.main.scale 1.0


# 
# heading: (selector,block) ->
#   @rule selector, =>
#     @fontFamily fonts.headings
#     @fontWeight 700
#     @color colors.text
#     @marginBottom "2rem"
#     block()
#     
# main: ->
#   
#   @import "url(http://fonts.googleapis.com/css?family=Gentium+Basic:400,700,400italic,700italic|Exo:300,400,700,300italic,700italic|Oxygen:400,700,300&subset=latin,latin-ext)"
#   @scale 0.75
#   
#   # General typography
#   @rhythm (1+1/3), (typeSize) =>
# 
#     @rule "body", =>
#       typeSize 2
#       @fontFamily fonts.labels
#       @fontWeight 400
#       @color colors.text
#       
#   # Headings
#   @rhythm (1+1/3), (typeSize) =>
#   
#     @heading "h1", => typeSize 5
#     @heading "h2", => typeSize 4
#     @heading "h3", => typeSize 3
#     @heading "h4", => typeSize 2
#     @heading "h5", =>
#       typeSize 2
#       @fontWeight 400
# 
#     for n in [1..5]
# 
#       # When headings follow each other, ex: h3 + h4, 
#       # pull them closer together
#       if n < 5
#         @rule "h#{n} + h#{n+1}", =>
#           @marginTop "-2rem"
#           @fontWeight 400
# 
#       # A heading following a paragraph gets a bit of extra
#       # margin on top ...
#       @rule "p + h#{n}", =>
#         @marginTop "2rem"
# 
# 
#   # Body text
#   @rhythm (1+1/3), (typeSize) =>
#     @rule "p, li", =>
#       typeSize 2
#       @fontFamily fonts.body
#       @fontWeight 400
#       @color colors.text
#       @marginBottom "1rem"
# 
#   # Forms
#   @rule "label, input, textarea, select", =>
#     @fontFamily fonts.labels
#     @padding "1rem"
# 
#   @rhythm 1.5, (typeSize) =>
#     @rule "label", =>
#       typeSize 2
#   
#   @rhythm 1.6, (typeSize) =>
#     @rule "input, textarea, select", =>
#       typeSize 2
#       
#     @rule "table p, table li, ul.menu li", =>
#       typeSize 2
#       @fontFamily fonts.labels
# 
#   @rhythm 1.05, (typeSize) =>
#     @heading ".call h1", => typeSize 5
#     @heading ".call h2", => typeSize 4
#     @heading ".call h3", => typeSize 3
#     @heading ".call h4", => typeSize 2
#     @heading ".call h5", => 
#       typeSize 2
#       @fontWeight 400
#     
#   @rule "strong", =>
#     @fontWeight 700
#     
#   @rule "em", =>
#     @fontStyle "italic"
#     
#   @rule "a", =>
#     @color colors.link
#     @textDecoration "none"
#     @outline 0
#     @lineHeight "inherit"
#     
#   @rule "a:hover", =>
#     @color lighten( colors.link )
