class Bootstrap 
  
  header: (content) ->
    @html.div
      class: "page-header"
      content: content    
    
  navbar: (options) ->
    classes = ["navbar"]
    classes.push "navbar-inverse" if options.inverse?
    classes.push "navbar-fixed-top" if options.fixed_top?
    @html.div
      class: classes.join(" ")
      content: @html.div 
        class: "navbar-inner"
        content: @container options.content

  brand: (name) ->
    @html.a
      href: "/"
      class: "brand"
      content: name
  
  navmenu: (items) ->
    @html.ul
      class: "nav"
      content: for item in items
        @html.li
          class: ("active" if item.active?)
          content: @html.a
            href: item.url
            content: item.text

  navtabs: (tabs) ->
  
    @html.div 
      class: "tabbable"
      content: [
        @html.ul
          class: "nav nav-tabs"
          content: for id,tab of tabs
            @html.li
              class: ["active" if tab.active?]
              content: @html.a
                href: "##{id}"
                "data-toggle": "tab"
                text: tab.label

        @html.div
          class: "tab-content"
          content: for id,tab of tabs
            @html.div
              class: ["tab-pane fade in","active" if tab.active?]
              id: id
              content: tab.content ]
  
        
  container: (items) ->
    @html.div
      class: "container"
      content: items
    
  hero: (items) ->
    @html.div
      class: "hero-unit"
      content: items
      
  row: (items) ->
    @html.div
      class: "row"
      content: items
  
  column: (width,items) ->
    @html.div
      class: "span#{width}"
      content: items
      
  button: (options) ->
    classes = [ "btn" ]
    classes.push "btn-primary" if options.primary?
    classes.push "btn-large" if options.large?
    @html.a
      href: options.url
      text: options.text
      class: classes.join(" ")
        
module.exports = Bootstrap