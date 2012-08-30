# nice


Component-based (instead of template-based) views for CoffeeScript.

Template-based views abandon all the powerful capabilities of programming languages, particularly the ability to reuse code. And they force us to learn a new template language instead of using one we already know.

Of course, there are good reasons we use templates. One of them is the difficulty of mixing data (the markup) and code. CoffeeScript does a great job of this and opens the door to fine-grained component-based views.

Nice provides the foundation for building component-based views.

## Status

*Very* early stages of development. Right now, Nice simply provides a way to generate HTML from CoffeeScript (or Javascript, but, honestly, it's too cumbersome to use that way). For example:

    @div [
      @h1 novel.title
      @h2
        class: "byline"
        text: novel.author
      @p novel.synopsis
    ]

Of course, that by itself isn't all that interesting, although it's certainly more readable than straight HTML. The really useful bit comes in when you start defining classes and methods that use this approach:

    class ComponentHTML extends HTML

      list: (list) ->
        @ul (@li @a item for item in list)

Here we've defined an `list` method that will take an array of objects and gives us back the HTML for a list of hyperlinks. We can now reuse that in other classes or even override it.

Let's suppose we want to encapsulate all the code related to displaying information about novels. We might define a class like this:

    class NovelHTML extends ComponentHTML

      description: (novel) ->
        @div [
          @h1 novel.title
          @h2
            class: "byline"
            text: novel.author
          @p novel.synopsis
          @div
            class: "characters"
            content: @characterList novel.characters
        ]

      characterList: (names) ->
        @list ({text: name, url: "novel://qubit/characters/#{name}"} for name in names)

We define `characterList` to be a wrapper around the `list` method above. Then we use that method within our `description` method.

So now we can replace templates with simple method invocations:

    novel = 
      title: "QUBIT"
      author: "Dan Yoder"
      synopsis: "When the first practical quantum computer is developed, an ambitious criminal exploits to steal trillions of dollars."
      characters: ["Ulysses Mercy","Vihaan Malhotra","Katya Brittain","Ray Austin"]

    novelHTML = new NovelHTML

    console.log beautify (novelHTML.description novel), 
      indent_size: 2
      indent_char: ' '
      max_char: 78

Which will give us the following HTML:

    <div>
      <h1>QUBIT</h1>
      <h2 class='byline'>Dan Yoder</h2>
      <p>When the first practical quantum computer is developed, an ambitious criminal
        exploits to steal trillions of dollars.</p>
      <div class='characters'>
        <ul class='menu'>
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
    </div>


## Future Plans

The next step is to build on this foundation to make it possible to add behaviors, such as making elements of a list draggable, using mixins. Since we can easily convert HTML strings like this into DOM trees with JQuery, we can write component-classes that use the HTML classes to generate DOM trees and then bind behaviors to them.

We can also do the equivalent of compilation by simply memo-izing the methods.

Finally, dynamic updating can be handled by simply adding methods at the component level (not the HTML level) that operate directly on the DOM. But they can potentially reuse the same code that generated the view in the first place. (This is part of what we mean by "fine-grained").

For example, if we have a method that defines how we are going to render a list element, we can use that code to generate the initial HTML, and then reuse it in the code that does in-place updates of the list.