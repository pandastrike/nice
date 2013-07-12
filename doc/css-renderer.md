# The CSS Renderer

The CSS renderer extends the Renderer class with methods for rendering CSS stylesheets. These include methods for defining rules and properties, helper methods for dealing with things like media queries and vendor prefixes, and mixins for typography, grids, and so on.

## Example

Typically, this renderer is used to define classes that correspond to a master application-specific stylesheets.

    {CSS} = require "nice"
    class MyStyleSheet extends CSS
    
      main: ->
      
        @rule "h1", =>
          @fontSize "4.5rem"
          @lineHeight "5rem"
          @marginBottom "2rem"
          
        @rule "p", =>
          @fontSize "1.6rem"
          @lineHeight "2rem"
          @marginBottom "1rem"
          
        @rule "img", =>
          @padding "0.5rem"
          @border "1px solid silver"
          @float "left"
          @marginRight "0.5rem"
          
    myStyleSheet = new MyStyleSheet
    myStyleSheet.main() # render the stylesheet
    
## Mixins

You can include mixins in your stylesheet with the `mixin` method. Mixins are basically functions that add methods or properties to your renderer.

You can define top level mixins, rule-level mixins, or property-level mixins. For example, the typography mixin defines a top-level (main) mixin called `rhythm` which, in turn, generates a function that you can use to set the font-size and line-height in a way that will preserve the specific "rhythm" (the ratio between the two).

Nice provides CSS renderer mixins for buttons, colors, themes, dialogs, forms, grid layout, themes, and typography. (Documentation coming soon.)

### Example: Typography Mixin

Here is the example above, but simplified by using the typography mixin:

{CSS} = require "nice"
class MyStyleSheet extends CSS

  main: ({rhythm})->
  
    rhythm 1.1, (typeSize) =>
    
      @rule "h1", =>
        typeSize 5
        @marginBottom "2rem"
      
      @rule "p", =>
        typeSize 2
        @marginBottom "1rem"
      
    @rule "img", =>
      @padding "0.5rem"
      @border "1px solid silver"
      @float "left"
      @marginRight "0.5rem"

## Media Queries

To make it easier to write responsive CSS, Nice's CSS renderer provides some helper functions. First, you define your breakpoints using the `breakpoint` method, like this:

    @breakpoint 
      desktop: """
        screen and (min-width: 72rem)
        """
      tablet: """
        screen and (min-width: 48rem) 
        and (max-width: 72rem)
        """
      mobile: """
        screen and (min-width: 20rem)
        and (max-width: 48rem)
        """
      tiny: """
        screen and (max-width: 20rem)
        """  

which, in turn, defines additional helper functions based on the names of your breakpoints. These can be accessed by invoking the `breakpoint` method and passing a function instead of an object:

    @breakpoint ({desktop, tablet, mobile, tiny}) =>
      
      desktop =>
        @rule "body", =>
          @width "72rem"

      tablet =>
        @rule "body", =>
          @width "48rem"
          
      mobile =>
        @rule "body", =>
          @width "20rem"
          
        @rule "nav", =>
          @display "none"

These helper functions will automatically wrap the contained CSS rules in the appropriate media query.

## Methods

#### `rule(selectors...,properties)`

Render a rule for the given `selectors` using the `properties` render function.

*Example*

This CSS rendering code:

    {CSS} = require "nice"
    css = new CSS
    
    css.rule "p, ul", ->
      css.marginBottom "2rem"
      
will generate this CSS:

    p, ul {
      margin-bottom: 2rem;
    }

#### `property(name,value)`

Renders a property declaration. This method is usually used simply to implement specific property methods, such as `marginBottom` or `width`.

#### `prefixProperty(name,value)`

Renders one property declaration for each browser prefix of `-moz` and `-webkit` as well as one free of prefixes.

For example, this declaration:

    @prefixProperty "boxOrient", "vertical"
    
will generate the following properties:

    -webkit-box-orient: "vertical";
    -moz-box-orient: "vertical";
    box-orient: "vertical";
    
As with `property`, this method is typically used to define specific property methods, such as `boxOrient`.

#### `context(selector,rules)`

Creates a `selector` context for the given `rules` render function. Any rules declared within the function will be relative to the context. Rule-level mixins are passed in to the `rules` function.

Simple selector combinator functions are provided to express the relationship between the rule selector and the context.

For example, the following rules will be defined relative to the `div.article` selector:

    {contains} = CSS.combinators
    
    @context "div.article", =>
      
      # div.article { ... }
      @rule =>
        # etc.
        
      # div.article p { ... }
      @rule contains("p"), =>
        # etc.
        
The available selectors are: `contains`, `sibling`, `child`, and `variant`, which correspond to space, `+`, `>`, and concatenation.

      # div.article p { ... }
      @rule contains("p"), =>
      
      # div.article + p { ... }
      @rule sibling("p"), =>
      
      # div.article > p { ... }
      @rule child("p"), =>
      
      # div.article.highlight { ... }
      @rule variant(".highlight")
      
(You don't have to use the combinators; they're are simple readability aids. You can also just write `@rule " p", => ...`, but it's easy to miss the space.)