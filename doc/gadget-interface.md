# Gadget Protocol

Gadgets are components meant to be run in a browser that implement an interface and follow certain other conventions, collectively known as _the Gadget protocol_.

## Creating A Gadget

Gadgets can be constructed like any other object. The constructor takes an object with the following properties:

* `class` - The CSS classname for the root DOM element of the component. This will also be used to construct a name for the Gadget if one is not provided. Defaults to the name of the class in "corset-case", ex: `article-summary` for a class named `ArticleSummary`.

* `name` - The name used to identify this Gadget _instance_ within the container. Defaults to the classname with a counter, ex: `article-1`.

* `events` - The event channel to broadcast events events on. The channel must conform to the Mutual protocol for event channels: in addition to `on` and `emit`, it must support constructing channels from the given channel.


## Attaching And Detaching

Gadgets are attached to the DOM by calling `attach` with a DOM element known as the Gadget _container_. They can be similarly detached by calling `detach`.

The _container_ is the parent of the Gadget's root element. When a Gadget attaches to a container, it first checks to see if it already has a DOM tree available. If not, it checks to see if the container has one available. Otherwise, it will render the necessary DOM.

## Decoration

When attaching, a DOM tree is _decorated_ using functions called _decorators_. Decorators take an object as an argument which has the following properties:

* `root` - This is the root of the DOM tree as a JQuery object.

* `gadget` - This is the Gadget instance itself.

This convention makes it possible to apply general purpose decorators that simply require a JQuery object as an argument. Gadget-specific decorates may use the `gadget` argument instead.

Gadget implementations can either override the `decorate` method (make sure to call `super`) or simply add decorators via the `decorator` method.

## Marking

When a Gadget is attached using a pre-rendered DOM tree, it sets the `name` property of the root DOM element to the Gadget's name. This prevents multiple Gadget instances from attempting to bind to the same DOM tree.

## Rendering

Each Gadget has a class-level `HTML` property. The value of this property must be an HTML renderer. The `render` method simply calls the HTML renderer. The renderer is expected to return an HTML string when finished.

## Deferred (Re-)Rendering

If a `load` method is defined on the Gadget, it will be called when building a new DOM tree. The `load` method is expected to return an event channel. The `success` handler will re-render the DOM, effectively updating the DOM once the Gadget has finished _loading_. You can define a `load` method can do any number of things, like making a call to an API, so long as it returns an event channel and emits a `success` event when finished.

### Partial Rendering

Gadgets may render DOM subtrees, which will trigger render events. However, the subtrees should be explicitly decorated if necessary, since the Gadget's DOM tree as a whole may already have been decorated.

## Properties

* `class` - The CSS class associated with the Gadget.

* `name` - The name associated with the Gadget. Together, the class and name of a Gadget must be unique within a given `container`.

* `decorators` - The array of decorator functions associated with Gadget.

* `decorated` - A boolean indicated whether or not the DOM tree has been decorated.

* `html` - An instance of the Gadget's renderer.

* `events` - The event channel used by the Gadget.

* `container` - The Gadget's container DOM element.

* `root` - The Gadget's root DOM element.

## Methods

* `attach( container )` - Add the Gadget to the container, rendering it's DOM, binding it, and decorating it, if necessary. Tis method is idempotent.

* `detach` - Remove the Gadget from it's `container` and remove any event handlers. This method is idempotent.

* `render` - Generate the Gadget's DOM tree by calling it's HTML renderer. Takes an optional rendering function.

* `build` - Generate a new DOM tree. Will also call a `load` method if it exists, and re-render the tree within the success handler.

* `loading` - Calls `load` if defined and adds a `success` handler to re-render the DOM.

* `load` - Load data for the Gadget. Optionally defined by derived classes.

* `decorate` - Apply all the Gadget's decorators to the DOM. This method is idempotent.

* `decorator` - Add a decorator to a Gadget.

* `mark` - Mark the DOM tree with the `name` of the Gadget.

* `candidate` - Returns a candidate DOM tree to bind to. See `candidates` below.

* `candidates` - Return a list of candidate DOM trees to bind to. These are nodes within the `container` that have the same `class` as the Gadget, are as yet unbound (that is, they haven't been marked).

* `replace` - Find a DOM node within the `container` that has already been bound and replace it with the Gadget's DOM tree. This is useful for re-rendering the tree.

