module.exports = ->
  
  @mixins.rule.button = =>

    @rule =>
      @display "inline-block"
      @minWidth "6rem"
      @marginLeft "1rem"
      @marginTop "1rem"
      @padding "0.5rem"
      @borderRadius "0.25rem"
      @verticalAlign "middle"
      @textAlign "center"
      @textDecoration "none"
      @fontFamily @theme.fonts.labels
      @fontWeight 700
    
    { variant } = @constructor.combinators
    @rule variant( ".small" ), =>
      @minWidth "4rem"


