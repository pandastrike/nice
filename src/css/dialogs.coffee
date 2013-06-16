module.exports = ->
  
  @mixins.rule.modal = =>
    @rule =>
      @display "none"
      @position "absolute"
      @top "50%"
      @left "50%"
      @width "36rem"
      @zIndex 100
      @padding "2rem"
      @borderRadius "0.25rem"
      @border "1px solid silver"
      @background @theme.colors.background
  