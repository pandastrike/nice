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