{Renderer,HTML,Page} = require "../src/nice"

# Create your mixins ...
class List

  list: (list) ->
    @ul class: "menu", =>
      (@li => @a href: item.url, (item.text)) for item in list

# Create top-level rendering classes
class Novel extends Renderer
  
  @include HTML, Page, List
  
  constructor: (@info) ->

  description: ->
    @header => 
      @text @info.title
      @h2 class: "byline", (@info.author)
    @div class: "container", =>
      @div class: "row", => 
        @div class: "four columns", =>
          @h1 "Synopsis"
          @p @info.synopsis
        @div class: "eight columns", =>
          @div class: "characters", => @characters()

  characters: ->
    @list ({text: name, url: "novel://qubit/characters/#{name}"} for name in @info.characters)


novel = new Novel
  title: "QUBIT"
  author: "Dan Yoder"
  synopsis: "When the first practical quantum computer is developed, an ambitious criminal exploits to steal trillions of dollars."
  characters: ["Lochan Cairnes","Vihaan Malhotra","Katya Brittain"]

console.log novel.render -> 
  novel.beautify ->
    novel.page body: -> novel.description()
