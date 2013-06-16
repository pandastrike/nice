module.exports = ({rhythm}) ->

  @mixins.rule.form = (field) =>
    
    @rule =>
      @border "1px solid silver"
      @borderRadius "0.25rem"
      @padding "2rem"
    
    field =>

      @rule => 
        @marginBottom "1rem"
    
      @rule "label", => 
        @display "inline-block"
        @padding "0.5rem"

      @rule "input, textarea, select, div.control", =>
        @display "inline-block"
        @width "100%"
        @border "1px solid silver"
        @borderRadius "0.25rem"
        @padding "0.5rem"

      @rule "input[type='radio']","input[type='checkbox']", =>
        @width "1.5rem"
    
      @rule "input[type='radio'] + label", 
        "input[type='checkbox'] + label", =>
          @width "calc(100% - 1.5rem)"
          @padding "0"

      rhythm ( 1 + 1/3 ), (typeSize) =>
        @rule "textarea", =>
          typeSize 1
          @height "5rem"
