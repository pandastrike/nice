module.exports = ->
  
  @mixins.property.cell = =>
    @display "inline-block"
    @paddingRight "2rem"
  
  @mixins.property.well = =>
    @padding "1rem"
    @marginBottom "1rem"
    @background @theme.colors.foreground
    @color @theme.colors.background
    @borderRadius "0.25rem"