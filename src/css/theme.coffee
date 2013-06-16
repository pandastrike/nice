module.exports = ->
  
  @theme.colors.highlight = @lighten( @theme.colors.foreground, 0.25 )

  @rule "body", =>
    @fontFamily @theme.fonts.body
    @color @theme.colors.foreground
    @backgroundColor @theme.colors.background    