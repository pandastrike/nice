module.exports = ->
  
  @rule "html *", =>
    @boxSizing "border-box"
  
  @rule "body", =>
    @width "72rem"
    @margin "auto"
    @marginTop "2rem"

  @rule "a", =>
    @color @theme.colors.link
    @textDecoration "none"
    @outline 0
    @lineHeight "inherit"

  @rule "a:hover", =>
    @color @lighten( @theme.colors.link, 0.25 )

  @mixins.main.status = (status) =>
    
    @rule ".#{status}", =>
      @color @theme.colors[status].foreground
      @backgroundColor @theme.colors[status].background

    @rule ".#{status}:hover", =>
      @color @lighten( @theme.colors[status].foreground, 0.25 )
      @backgroundColor @lighten( @theme.colors[status].background, 0.25 )
  