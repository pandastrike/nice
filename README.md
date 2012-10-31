# nice

Component-based (instead of template-based) views for CoffeeScript.

Template-based views abandon all the powerful capabilities of programming languages, particularly the ability to reuse code. And they force us to learn a new template language instead of using one we already know.

Of course, there are good reasons we use templates. One of them is the difficulty of mixing data (the markup) and code. CoffeeScript does a great job of this and opens the door to fine-grained component-based views.

Nice provides the foundation for building component-based views.

## Status

*Very* early stages of development. 

## Getting Started

Nice provides an simple way to generate HTML from CoffeeScript (or Javascript, but, honestly, it's too cumbersome to use that way). For example:

    @div =>
      @h1 novel.title
      @h2 class: "byline", novel.author
        text: novel.author
      @p novel.synopsis

Of course, that by itself isn't all that interesting, although it's certainly more readable than straight HTML. The really useful bit comes in when you start defining classes and methods that use this approach:

    class Components

      list: (list) ->
        @html.ul =>
          (@html.li => @html.a href: item.url, (item.text)) for item in list

Here we've defined a `list` method that will take an array of objects and gives us back the HTML for a list of hyperlinks. We can now reuse that in other classes or even override it.

### Bootstrap Support

This is exactly what the Nice Bootstrap mixin does. You can write this:

    @navbar inverse: true, fixed_top: true, =>
      @brand "Nice"
      # etc ...
          
And, of course, you can easily define your own mixins.

### An Example

Let's suppose we want to encapsulate all the code related to displaying information about novels. We might define a class like this:

    class NovelHTML
  
      constructor: (@novel) ->
        @H = new HTML
        @B = new Bootstrap @H

      description: ->
        @B.header => 
          @H.h1 @novel.title
          @H.h2 class: "byline", (@novel.author)
        @B.container =>
          @B.row => 
            @B.column 4, =>
              @H.h1 "Synopsis"
              @H.p @novel.synopsis
            @B.column 4, =>
              @H.div class: "characters", => @characterList()

      characterList: ->
        @H.ul =>
          for name in @novel.characters
            @li => @a href: "#{@novel.url}/characters/#{name}", name

So now we can replace templates with simple method invocations:

    html = new NovelHTML
      title: "QUBIT"
      url: "http://rocket.ly/qubit"
      author: "Dan Yoder"
      synopsis: "When the first practical quantum computer is developed, an ambitious criminal exploits to steal trillions of dollars."
      characters: ["Ulysses Mercy","Vihaan Malhotra","Katya Brittain","Ray Austin"]
    
    console.log HTML.beautify html.description()

Which will give us the following HTML:

    <div>
      <h1>QUBIT</h1>
      <h2 class='byline'>Dan Yoder</h2>
      <p>When the first practical quantum computer is developed, an ambitious criminal
        exploits to steal trillions of dollars.</p>
      <ul>
        <li><a href='novel://qubit/characters/Ulysses Mercy'>Ulysses Mercy</a>
        </li>
        <li><a href='novel://qubit/characters/Vihaan Malhotra'>Vihaan Malhotra</a>
        </li>
        <li><a href='novel://qubit/characters/Katya Brittain'>Katya Brittain</a>
        </li>
        <li><a href='novel://qubit/characters/Ray Austin'>Ray Austin</a>
        </li>
      </ul>
    </div>


## Nice Versus Templates

Over the years, we've experimented with a number of different approaches to this problem. And we've also heard the common objections.

### Designer-Friendly

Since designers already know HTML, the theory is that the learning curve for template-based approaches is shorter. Therefore, in order to integrate designers into your workflow effectively, you must use templates.

You know where I remember hearing this argument? When CSS was in its early stages of adoption. It was supposedly too complicated for designers to learn. The reality is that designers learn what they need to in order to get results. Over the years, they've mastered not only CSS, but Less and its relatives, various template languages (ranging from ERb to Handlebars), all manner of Photoshop filters, and, in some cases, Flash.

Oh, and have we discussed JQuery? How many designers have learned at least a smattering of Javascript by now? And CoffeeScript is just a small leap from Javascript and better for designers to work with because it hides some of the idiosyncrasies of Javascript.

And I'm not convinced that, provided the language is expressive enough, that code-based HTML generation isn't actually easier even for designers well-versed in HTML. Is this:

    @div =>
      @h1 novel.title
      @h2 class: "byline", novel.author
      @p novel.synopsis

really that much more difficult for a designer to deal with than this:

    <div>
      <h1>{novel.title}</h1>
      <h2 class='byline'>{novel.author}</h2>
      <p>{novel.synopsis}</p>
    </div>

### Separation Of Concerns

Another argument often given in favor of templates, at least those like Mustache or Handlebars, is that they enforce a strict separation of concerns between presentation logic and application logic. Which is nice, but what about *all the rest of your code?*

Separation of concerns is a design principle that is ideally carried out through all parts of an application, right? Yet we don't pine for ways to enforce that anywhere else. We understand that it is simply part of the development process. And we also understand that sometimes it's okay to make exceptions, especially when working on early iterations of an application.

Strictly enforcement *any* design principle is, in a sense, the antithesis of both agile development and good design generally. Hermetic abstractions are usually bad, especially for developers that know what they're doing.

And let's not forget about the fact that, more and more, we live in a world with rich clients, where a lot of behavior is implemented client-side anyway. Fanatically enforcing separation of concerns for generating HTML is pointless if that separation can be (and often is) trivially compromised in JQuery event handlers.

### Code Is More Powerful Than Templates 

But even if none of that is convincing, the reality is that the reason to use an approach like Nice is that it's more powerful. You get inheritance, mixins, encapsulation, etc. Template-based approaches usually end up with a mix of conventions for using HTML along with course-grained templates. But what you really want is consistency and simplicity.

The Bootstrap mixin is a great example of this principle at work. Even the simplest things, like how to display lists or form elements, are encapsulated. You can override something, like how links are rendered, and those changes are reflected everywhere.

As your applications become more responsive, fine-grained rendering is more and more important. You don't want to re-render an entire chunk of your page because one thing changed. You want to re-render just the part that changed. You can't do that with course-grained templates. But using templates with a more fine-grained approach is too complicated, because templates aren't a programming language.

## Future Plans

* We can make it possible to add behaviors, such as making elements of a list draggable, using mixins. Since we can easily convert HTML strings like this into DOM trees with JQuery, we can write component-classes that use the HTML classes to generate DOM trees and then bind behaviors to them.

* We can also do the equivalent of compilation by simply memo-izing the methods.

* Dynamic updating can be handled by simply adding methods at the component level (not the HTML level) that operate directly on the DOM. But they can potentially reuse the same code that generated the view in the first place. (This is part of what we mean by "fine-grained").

For example, if we have a method that defines how we are going to render a list element, we can use that code to generate the initial HTML, and then reuse it in the code that does in-place updates of the list.
