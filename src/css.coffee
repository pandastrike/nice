Renderer = require "./renderer"
{w} = require "fairmont"
{sprintf} = require "sprintf"

snakeCaseToCamelCase = (string) -> 
  string.replace /(\-[a-z])/g, ($1) -> 
    $1[1].toUpperCase()

module.exports = class CSS extends Renderer
  
  @makeProperty = (property) ->
    method = snakeCaseToCamelCase( property )
    CSS::[method] = (value) ->
      @property( property, value )
    
  @makePrefixProperty = (property) ->
    method = snakeCaseToCamelCase( property )
    CSS::[method] = (value) ->
      @prefixProperty( property, value )
  
  @main: ->
    (new @).main()
    
  @combinators:
    contains: (string) -> " #{string}"
    variant: (string) -> string
    sibling: (string) -> " + #{string}"
    child: (string) -> " > #{string}"
    
  constructor: ->
    @selectors = [""]
    @mixins =
      main: {}
      rule: {}
      property: {}
      breakpoint: {}
    super
    
  mixin: ->
    for mixin in arguments
      mixin.call( @, @mixins.main )
      
  number: (number,units) ->
    sprintf( "%.2f%s", number, units )

  import: (reference) ->
    @text "@import #{reference};\n\n"

  important: (value) ->
    "#{value} !important"
    
  media: (query,rules) ->
    @text "@media #{query} {\n"
    do rules
    @text "}\n\n"
    
  context: (selector,fn) ->
    [ rest..., last ] = @selectors
    @selectors.push( "#{last}#{selector}" )
    fn( @mixins.rule )
    @selectors.pop()
    @buffer

  breakpoint: (fn) ->
    fn( @mixins.breakpoint )
    
  rule: ->
    
    [ selectors..., properties ] = arguments
    
    selectors.push( "" ) if selectors.length == 0
    
    [rest...,context] = @selectors
    selectors = for selector in selectors
      "#{context}#{selector}"
    
    selector = selectors.join(", ")

    @text "#{selector} {\n"
    properties( @mixins.property )
    @text "}\n\n"
  
  property: (name, value) ->
    @text "  #{name}: #{value};\n"

  # TODO: this might be a bit simplistic; often
  # prefixes are used in one browser but not another
  # see below ...
  prefixProperty: (name, value) ->
    @property "-webkit-#{name}", value
    @property "-moz-#{name}", value
    @property name, value
    
  block: (fn) ->
    fn( @mixins.main )
    @buffer 
    
  display: (value) ->
    if value == "flexbox"
      @block =>
        for prefixed in w "flexbox -moz-box -webkit-box"
          @property "display", prefixed
    else
      @property "display", value
  
  flex: (value) ->
    @property "flex", value

    # new syntax
   # @property "-webkit-flex", value

    # old syntax
    @property "-webkit-box-flex", value
    @property "-moz-box-flex", value

  flexOrient: (value) ->
    @property "box-orient", value
    @property "-webkit-box-orient", value
    @property "-moz-box-orient", value
    
  flexWrap: (value) ->
    @property "-webkit-flex-wrap", value
    @property "-moz-flex-wrap", value    

# from http://www.w3.org/TR/CSS21/propidx.html
CSS.makeProperty( property ) for property in w "azimuth background-attachment 
  background-color background-image background-position background-repeat 
  background 
  border border-collapse border-color border-spacing border-style border-width 
  border-top border-top-color border-top-style border-top-width 
  border-bottom border-bottom-color border-bottom-style border-bottom-width 
  border-left border-left-color border-left-style border-left-width 
  border-right border-right-color border-right-style border-right-width 
  caption-side clear clip color content counter-increment 
  counter-reset cue-after cue-before cue cursor direction elevation 
  empty-cells float font-family font-size font-style font-variant font-weight 
  font height left letter-spacing line-height list-style-image 
  list-style-position list-style-type list-style 
  margin margin-left margin-right margin-top margin-bottom
  max-height max-width min-height min-width orphans outline-color 
  outline-style outline-width outline overflow padding-top 
  padding padding-top padding-bottom padding-left padding-right
  page-break-after page-break-before page-break-inside pause-after 
  pause-before pause pitch-range pitch play-during position quotes richness 
  right speak-header speak-numeral speak-punctuation speak speech-rate stress 
  table-layout text-align text-decoration text-indent text-transform top 
  unicode-bidi vertical-align visibility voice-family volume white-space 
  widows width word-spacing z-index"
  
# other properties that have become de facto standardized
CSS.makeProperty( property ) for property in w "border-radius opacity"

# see http://peter.sh/experiments/vendor-prefixed-css-property-overview/
# to add to this list
CSS.makePrefixProperty( property ) for property in w "box-sizing box-shadow 
  column-count column-gap column-rule-color column-rule-style   
  column-rule-width"

for name in w "Basics Buttons Colors Dialogs Forms Grid Theme Typography"
  do (name) ->
    Object.defineProperty CSS, name, 
      get: -> require "./css/#{name.toLowerCase()}"
      enumerable: true
