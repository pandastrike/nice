HTML = require "../../../src/html"
beautify = require "../../src/beautify-html"

class ComponentHTML extends HTML

  list: (list) ->
    @ul
      class: "menu"
      content: (@li @a item for item in list)


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