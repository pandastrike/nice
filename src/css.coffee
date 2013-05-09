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
  
  constructor: ->
    @selectors = []
    super
    
  rule: (args...) ->
    
    if args.length == 2
      [selector,properties] = args
    else
      [properties] = args
      selector = ""
      
    selector = [ @selectors..., selector ].join(" ")

    @text "#{selector} {\n"
    properties()
    @text "}\n\n"
    
  # TODO: this might be a bit simplistic; often
  # prefixes are used in one browser but not another
  # see below ...
  prefixProperty: (name, value) ->
    @property "-webkit-#{name}", value
    @property "-moz-#{name}", value
    @property name, value
    
  property: (name, value) ->
    @text "  #{name}: #{value};\n"
    
  percent: (value) ->
    sprintf( "%.2f%%", value * 100 )
      
  # used to render with loops
  block: (fn) ->
    fn()
    @buffer 
    
  context: (selector,fn) ->
    @selectors.push( selector ) 
    fn()
    @selectors.pop()
    @buffer
    
  import: (reference) ->
    @text "@import #{reference};\n\n"
    
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
  background border border-collapse border-color border-spacing border-style 
  border-top border-top-color border-top-style border-top-width border-width 
  border-bottom caption-side clear clip color content counter-increment 
  counter-reset cue-after cue-before cue cursor direction elevation 
  empty-cells float font-family font-size font-style font-variant font-weight 
  font height left letter-spacing line-height list-style-image 
  list-style-position list-style-type list-style 
  margin margin-left margin-right margin-top margin-bottom
  max-height max-width min-height min-width orphans outline-color 
  outline-style outline-width outline overflow padding-top padding 
  page-break-after page-break-before page-break-inside pause-after 
  pause-before pause pitch-range pitch play-during position quotes richness 
  right speak-header speak-numeral speak-punctuation speak speech-rate stress 
  table-layout text-align text-decoration text-indent text-transform top 
  unicode-bidi vertical-align visibility voice-family volume white-space 
  widows width word-spacing z-index"
  
# other properties that have become de facto standardized
CSS.makeProperty( property ) for property in w "border-radius"

# see http://peter.sh/experiments/vendor-prefixed-css-property-overview/
# to add to this list
CSS.makePrefixProperty( property ) for property in w "box-sizing box-shadow"

# rgb <-> hsl algorithms from
# http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript

CSS.Colors = 
  
  # Converts an RGB color value to HSL. Conversion formula
  # adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  # Assumes r, g, and b are contained in the set [0, 255] and
  # returns h, s, and l in the set [0, 1].
  #
  # @param   Number  r       The red color value
  # @param   Number  g       The green color value
  # @param   Number  b       The blue color value
  # @return  Array           The HSL representation
  #
  rgbToHsl: (r, g, b) ->
    r /= 255
    g /= 255
    b /= 255
    max = Math.max(r, g, b)
    min = Math.min(r, g, b)
    l = (max + min) / 2

    if max == min
      h = s = 0 # achromatic
    else
      d = max - min
      s = if l > 0.5 then d / (2 - max - min) else d / (max + min)

      switch max
        when r
          h = (g - b) / d + (if g < b then 6 else 0)
        when g
          h = (b - r) / d + 2
        when b
          h = (r - g) / d + 4

      h /= 6

    [h, s, l]

  #
  # Converts an HSL color value to RGB. Conversion formula
  # adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  # Assumes h, s, and l are contained in the set [0, 1] and
  # returns r, g, and b in the set [0, 255].
  #
  # @param   Number  h       The hue
  # @param   Number  s       The saturation
  # @param   Number  l       The lightness
  # @return  Array           The RGB representation
  #
  hslToRgb: (h, s, l) ->
    if s == 0
      r = g = b = l # achromatic
    else
      hue2rgb = (p, q, t) ->
        if t < 0 then t += 1
        if t > 1 then t -= 1
        if t < 1/6 then return p + (q - p) * 6 * t
        if t < 1/2 then return q
        if t < 2/3 then return p + (q - p) * (2/3 - t) * 6
        return p

      q = if l < 0.5 then l * (1 + s) else l + s - l * s
      p = 2 * l - q
      r = hue2rgb(p, q, h + 1/3)
      g = hue2rgb(p, q, h)
      b = hue2rgb(p, q, h - 1/3)

    [r * 255, g * 255, b * 255]

  # turn a CSS compatible hex string to an rgb triple.
  #  
  # @param   String  colr     A hex color value. With or without leading "#".
  # @return  Array   rgb      An RGB triple with values in the set [0, 255].
  #
  rgbify: (colr) ->
    colr = colr.replace /#/, ''
    if colr.length is 3
      [
        parseInt(colr.slice(0,1) + colr.slice(0, 1), 16)
        parseInt(colr.slice(1,2) + colr.slice(1, 2), 16)
        parseInt(colr.slice(2,3) + colr.slice(2, 3), 16)
      ]
    else if colr.length is 6
      [
        parseInt(colr.slice(0,2), 16)
        parseInt(colr.slice(2,4), 16)
        parseInt(colr.slice(4,6), 16)
      ]
    else
      # just return black
      [0, 0, 0]

  # rgb to css compatible hex color string.
  #  
  # @param   Array   rgb    An RGB color triple.
  # @return  String  rgb    The color in CSS style hex with leading "#"
  #
  hexify: (rgb) ->
    colr = '#'
    r = Math.floor(rgb[0]).toString(16)
    g = Math.floor(rgb[1]).toString(16)
    b = Math.floor(rgb[2]).toString(16)
    sprintf("#%02s%02s%02s",r,g,b)

  # lighten color by percent of its current lightness. NOTE: this means colors that 
  # start darker will need a much higher `percent` value to make them appear brighter.
  #
  # @param   Array or String  rgb      An RGB color description.
  # @param   Float            percent  A percentage value >= 0
  # @return  String           hex      A hex string of the new color.
  # 
  lighten: (rgb, percent) ->
    rgb = @rgbify(rgb) if typeof rgb == 'string'
    hsl = @rgbToHsl.apply this, rgb
    lightness = hsl[2] + (hsl[2] * percent)
    lightness = Math.min 1.0, lightness
    return @hexify(@hslToRgb(hsl[0], hsl[1], lightness))

  # darken a color by a percentage of its current lightness
  #
  # @param   Array or String  rgb      An RGB color description.
  # @param   Float            percent  A percentage value >= 0
  # @return  String           hex      A hex string of the new color.
  # 
  darken: (rgb, percent) ->
    rgb = @rgbify(rgb) if typeof rgb is 'String'

    hsl = @rgbToHsl.apply(this, rgb)
    lightness = hsl[2] - (hsl[2] * percent)
    lightness = Math.max 0.0, hsl[2]
    return @hexify @hslToRgb(hsl[0], hsl[1], lightness)
