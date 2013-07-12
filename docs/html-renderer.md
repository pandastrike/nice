# The HTML5 Renderer

The HTML5 renderer extends the Renderer class with a host of tag methods for rendering HTML markup. Tag methods can take a object whose properties are tag attributes and a string or function as the content.

### Ex: the DIV tag

The following code:

    {HTML} = require "nice"
    html = new HTML
    html.div id: "bar', class: "foo", "Baz"
    
would generate the following HTML:

    <div id="bar" class="foo">Baz</div>
    
All argument are optional.

If no content is specified (that is, no string or function is passed in), an empty tag will result. Some tags are _self-closing_ tags, which means that if there is no content, a self-closing tag will be generated, ex: `<hr/>`.

### Usage

Typical use is to define a class that extends the HTML renderer and then define a `main` method and any helper methods (in particular, those that might be used to update the DOM dynamically after the initial render is complete).

    {HTML} = require "nice"
    
    class ContactForm extends HTML
    
      main: ->
        
        @form class: "contact-form", =>
          @h1 "Contact Form"
          
          @field => 
            @label "Name"
            @input name: "name", type: "text"
            
          @field => 
            @label "Address"
            @input name: "address", type: "text"
        
      # helper methods
      
      field: (content) ->
        @div class: "field", content
        
      # used to dynamically display error messages in the browser
      error: (message) ->
        @p class: "error", message
        
To render the form initially, we just instantiate our `ContactForm` renderer and call `main`:

    html = new ContactForm
    html.render -> html.main()
    
Later, if we detect an error, we can render it using the same object, and update the DOM:

    $(".contact-form input[name='address']").append html.render =>  
      html.error "Please enter an address."