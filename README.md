# nice

Nice is an emerging, component-oriented framework for building the HCI for Web apps. It includes HTML and CSS rendering engines, a component class, and an "evented data" adapter. In addition, Nice leverages these elements to provide a component architecture along with a library of pre-built components.

## Status

Early stages of development. 

## Motivation

With all the frameworks out there - Backbone.js, Ember, Angular.js just to name a few client-side frameworks - you might wonder why we built yet another one. As we develop the framework, we'll obviously provide documentation on how to use it. But for now, here are a few of our motivations.

### Code Instead Of Templates

We typically use HTML templates to generate markup. In some cases, we use full-on template languages. But these are ultimately a poor substitute for what we already have, which is a full-featured programming language.

CoffeeScript's syntax helps here because it lends itself to a functional style of coding. For example, here's some simple markup:

    @header =>
      @nav =>
        do @logo
        do @tagLine
    do @feature
    @aside =>
      do @services
      do @technology

We have the full power of CoffeeScript at our disposal. We can define base classes, mixins, whatever we want. 

Here's another example showing the use of classes and attributes along with helper functions (in this case `field`):

    @field "Title", =>
      @input 
        name: "title", type: "text"
        placeholder: "Enter a title"

### Code Instead Of Preprocessors

We can do the same trick with CSS. Rather than learning yet another specialize language, like Less, let's just use CoffeeScript:

    @rule "body", =>
      @margin "auto"
      @marginTop "2rem"

To give you an idea of the power of this approach, let's look at how Nice helps you deal with breakpoints in responsive design.

First, let's define our breakpoints:

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
  
Now, we can use them just by passing a function into the `breakpoint` method:

    @breakpoint ({desktop, tablet, mobile, tiny}) =>

        @rule "body", =>
          @margin "auto"
          @marginTop "2rem"

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

### Components Instead of MVC

The original Smalltalk MVC model was component-oriented. Nice provides a component-framework called Gadgets. Each Gadget is self-contained and uses events to communicate with other Gadgets and your application. You simply define a method to render the necessary HTML (which you can do inline with the HTML renderer we discussed above) decorate the DOM with event handlers. 

For example, here's the `decorate` method for a search Gadget in one our applications:

    decorate: ->
      search = =>
        term = @$.find("input").val().replace(/\s+/g,"-")
        @events.emit "search", term
        false
    
      @$.find("a[href='search']").click search
      @$.find("input").change search
  
      super

The Nice Gadget framework takes care of make sure this method gets called when necessary so you don't have to worry about it. You just attach and detach components into your application and Nice takes care of the rest.

You can even create data-aware components. Here's some markup for a form that will automatically fill itself in once data is bound to the component (by assigning a value to its `data` property):

    @form =>
  
      @field "Key", =>
        @input 
          name: "key", type: "text"
          placeholder: "Enter the URL key here"
  
      @field "Name", =>
        @input 
          name: "name", type: "text"
          placeholder: "Enter a name here"


Looks like any other markup, right? That's because Nice simply checks the `attribute`. (You can give Nice hints when it guesses wrong as to what to do with a binding with special `data` attributes).

### Events Instead Of Callbacks

Nice is intensively event-oriented. There's even a way to wrap your data objects so that they automatically generate events when they're changed. Since Nice automatically generates change events for bound form elements, all you have to do is handle the change events.

Here's how we code a form that automatically saves the data object whenever something is modified:

    @events.on "data.*.change", => do @save

Yep. That's it. One line of code. (Of course, you still have to implement the `save` itself.)

Nice uses [Mutual][1] for event handling, so you can also do things like create event hierarchies and general purpose error handlers instead of defining error handlers for ever single possible event.

[1]:http://github.com/dyoder/mutual

### HTML, CSS, and Javascript: The Assembly Language Of The Web

The Open Web is awesome. It's an amazing fact that we have this standardized set of technologies that allow us to build multi-platform applications with a single codebase. That said, these technologies have been evolving, sometimes in unexpected ways, for nearly two decades now, and ... well ... it shows. Web development can get a bit messy as a result.

What do we do when things get messy? We introduce a layer of abstraction! Just as C provides a higher-level programming interface than assembler, and languages like JavaScript provide an a higher-level programming interface than C, so, too does Nice, with a big assist from CoffeeScript, provide a higher-level programming interface for Web technologies.