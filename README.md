# nice


Component-based (instead of template-based) views for CoffeeScript.

Template-based views abandon all the powerful capabilities of programming languages, particularly the ability to reuse code. And they force to learn a new template language instead of using one we already know.

There are good reasons we use templates. One of them is the difficulty of mixing data (the markup) and code. CoffeeScript does a great job of this and opens the door to fine-grained component-based views.

Nice provides the foundation for building component-based views.

## Status

*Very* early stages of development. Right now, Nice simply provides a way to generate HTML from CoffeeScript (or Javascript, but, honestly, it's too cumbersome to use that way). For example:

    @div [
      @h1 novel.title
      @h2
        class: "byline"
        text: novel.author
      @p novel.synopsis

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

## Future Plans

The next step is to build on this foundation to make it possible to add behaviors, such as making elements of a list draggable, using mixins. Since we can easily convert HTML strings like this into DOM trees with JQuery, we can write component-classes that use the HTML classes to generate DOM trees and then bind behaviors to them.