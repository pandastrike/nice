class Bootstrap 
  
  constructor: (options) -> {@html} = options

  container: (content) ->
    @html.div class: "container", content
  
  row: (content) ->
    @html.div class: "row", content

  column: (options,content) ->
    {width,offset} = options
    classes = ["span#{width}"]
    classes.push "offset#{offset}" if offset?
    @html.div class: classes, content

  header: (content) ->
    @html.div class: "page-header", content
    
  hero: (content) ->
    @html.div class: "hero-unit", content
    
  navbar: (options,content) ->
    {inverse,fixedTop} = options
    classes = ["navbar"]
    classes.push "navbar-inverse" if inverse?
    classes.push "navbar-fixed-top" if fixedTop?
    @html.div class: classes, => 
        @html.div class: "navbar-inner", content

  navmenu: (items) ->
    @html.ul class: "nav", =>
      for item in items
        {text,url} = item
        @html.li class: ("active" if item.active?), =>
          @html.a href: url, text

  navtabs: (tabs) ->
    @html.div class: "tabbable", =>
      @html.ul class: "nav nav-tabs", =>
        for id,tab of tabs
          @html.li class: ("active" if tab.active?), =>
            @html.a 
              href: "##{id}"
              "data-toggle": "tab"
              tab.label
    
      @html.div class: "tab-content", =>
        for id,tab of tabs
          @html.div 
            id: id
            class: ["tab-pane fade in","active" if tab.active?]
            tab.content
  
  brand: (name) ->
    @html.a class: "brand", href: "/", name
        
  button: (options) ->
    {large,primary,url,text} = options
    classes = [ "btn" ]
    classes.push "btn-primary" if primary?
    classes.push "btn-large" if large?
    @html.a class: classes, href: url, text
        
module.exports = Bootstrap