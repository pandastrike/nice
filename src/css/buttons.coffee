module.exports = ->
  
  @mixins.rule.button = =>

    @rule =>
      @display "inline-block"
      @minWidth "6rem"
      @padding "1rem"
      @borderRadius "0.25rem"
      @verticalAlign "middle"
      @textAlign "center"
      @textDecoration "none"
      @fontFamily @theme.fonts.labels
      @fontSize "2rem"
      @fontWeight 700
    
    { variant } = @constructor.combinators
    @rule variant( ".small" ), =>
      @minWidth "4rem"
      @fontSize "1rem"


