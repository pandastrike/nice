{HTML,Bootstrap} = require "nice"

class Component

  constructor: (@html) -> 
    
  list: (list) ->
    @html.ul class: "menu", =>
      (@html.li => @html.a href: item.url, (item.text)) for item in list

class Novel
  
  constructor: (@novel) ->
    @H = new HTML
    @B = new Bootstrap @H
    @C = new Component @H

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
    @C.list ({text: name, url: "novel://qubit/characters/#{name}"} for name in @novel.characters)


novel = new Novel
  title: "QUBIT"
  author: "Dan Yoder"
  synopsis: "When the first practical quantum computer is developed, an ambitious criminal exploits to steal trillions of dollars."
  characters: ["Ulysses Mercy","Vihaan Malhotra","Katya Brittain","Ray Austin"]

console.log HTML.beautify novel.description(),
  indent_size: 2
  indent_char: ' '
  max_char: 78