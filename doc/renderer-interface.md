# The Renderer Interface

A renderer is an object with a buffer and functions that write to that buffer. It has a `render` method that takes a rendering function. Rendering functions are typically used to write to the buffer, rendering some discrete output, like a Web page or a CSS file. The `render` method itself takes care of resetting the buffer so that the renderer can be used again.

Nice provides to pre-built renderers for [HTML5][html5] and [CSS][css].

[html5]:./html-renderer.md
[css]:./css-renderer.md

## Properties

#### `buffer`

A string containing the contents of the renderer's buffer.

## Constructor

#### `constructor(buffer="")`

Create a renderer initialized with an optional buffer.

## Methods

#### `text(string)`

Add a string of text to the buffer. This method is typically called by other, semantically richer, methods.

#### `render(function)`

Resets the buffer and calls the given function, returning the buffer once the function returns. The main purpose of this method is to make it more convenient to reuse a Renderer.

    # Generate the contact form HTML
    $("div.contact-form").html contactForm.render => contactForm.main()
  
    # Later, we want to dynamically update one of the lookups ...
    $("div.contact-form select.state").change ({target}) =>
      $("div.contact-form select.city").html myForm.render =>
        myForm.cityLookup($(target).val())  

You can, of course, clear the buffer yourself. These two things are roughly equivalent:

    # Use render
    r.render => r.text "hello"      # returns 'hello'
    r.render => r.text "world"      # returns 'world'
    
    # Do it yourself
    r.render => r.text "hello"      # returns 'hello'
    r.buffer = ""
    r.render => r.text "world"      # returns 'world'
    
If you don't use `render` (or otherwise reset the buffer), you'll just keep adding to it:

    r = new Renderer
    r.text "hello"                  # returns 'hello'
    r.text " world"                 # returns 'hello world'
    
## Building Your Own Renderers

Creating a renderer is mostly a matter of simply of adding methods that each return the buffer after they've finished adding to it. For example, here's a simple HTML-based renderer:

    class HTML extends Renderer
    
      heading: (string) ->
        @text "<h1>#{string}</h1>"
        
      paragraph: (string) ->
        @text "<p>#{string}</p>"
        
      list: (items...) ->
        @text "<ul>"
        @text "<li>#{item}</li>" for item in items
        @text "</ul>"

We can now use our renderer like this:

    html = new HTML
    console.log html.render =>
    
      html.heading "Renderers"
    
      html.paragraph "Nice provides the following pre-built renderers:"
    
      html.list "HTML", "CSS" 
      
Which would print (prettified):

    <h1>Renderers</h1>
    <p>Nice provides the following pre-built renderers:</p>
    <ul>
      <li>HTML</li>
      <li>CSS</li>
    </ul>