# README

## What I knew

[Stimulus Reflex](https://docs.stimulusreflex.com/) is a framework for creating "reactive" UIs that uses websockets (via actioncable) and server-side rendering for events/UI updates.

## What I expected

A way to create isolated "components" (either ViewComponents or just plain views) that can trigger events in the backend and as a result get their entire HTML replaced with an updated markdown. I had Elm apps in mind.

## What I found

* It works pretty much out of the box, at least in a new Rails app.
* It generates some boilerplate both for StimulusJS and for Reflex and it's somewhat difficult to figure out what's needed for what, especially regarding Reflex's dependency on StimulusJS. Do I need Stimulus controllers? What do I need from `app/javascript/controllers`? Are things in `app/reflexes` somehow connected to the things in `app/javascript/controllers`? Stuff like that.
* The fact that "component" state is not stored in the UI is actually a big one and it is quite a paradigm shift. It took me quite some thinking sometimes until I realised that what I was trying to do made no sense within the context of Reflex. The aim is to create apps that will display the same thing if the user refreshes the page, nothing is actually stored in JS, which is really great. (Hence the need for an sqlite db for keeping the counts. Could've used session but meh.)
* Page morphs are Reflex responses that rerender the entire page in the browser window. It should be the "simple case" but I found it pretty non-trivial in more than one way. They trigger the Rails controller action that rendered the page originally but the Reflex action handler also gets executed. I don't really know in what order these things happen. Do the contexts of the Rails controller and the Reflex handler get merged somehow? Do they run in some order and `@assigns` can get overridden?
* Also, there can be HTML tags marked with the `data-reflex-permanent` attribute which will be ignored by the Reflex redraw. Except in some cases when it will ignore this attribute. ¯\_(ツ)_/¯.
* Page morphs can also be scoped to a container so they essentially become non-page morphs, which is not the same as a selector morph because the Rails controller action will still be retriggered, which makes it very difficult to mentally follow what's happening with the page.
* Selector morphs are Reflex responses that change the inner HTML of a container. Turns out, however, there is no way to scope them to a "component". There is no logical binding between a reflex handler and the view that rendered the container that contained the element that was the source of the event. In fact, the `morph` action takes an arbitrary CSS selector and uses it as the target for the HTML injection. I think this approach inevitably leads to a rather shitty app design in which elements in a page can interact with arbitrary containers, completely breaking component encapsulation.
* When containers have unique HTML ids, morphs can be aimed easily but when there are multiple instances of the same "component" on the page, like in this example, things get hacky and elements need to be identified somehow. I used model ids in data attributes and I strongly dislike it.
* I actually found it pretty difficult to come up with a HTML structure that makes it easy to identify meaningful targets for morphs. Logic would dictate that the ideal morph target would be a div that wraps the contents of a partial. In this code code each counter is wrapped in a `div class="container"` that is INSIDE the ViewComponent, which is also the target of the morph, see `def container_selector`. One would think that each button click will result in a new nested div, which doesn't happen for some reason. However, it does with the commented out container selector. ¯\_(ツ)_/¯

## The code

The fact that I use a ViewComponent doesn't actually add or change anything in the way the Reflex handler is doing its thing.

The few files of interest are:

* `app/components/counter_component.html.erb`
* `app/reflexes/counter_reflex.rb`

## To set up

```
docker run --rm --name redis -p 6379:6379 -d redis:alpine # if no redis is running
bundle install
yarn
bundle exec rails db:setup
bundle exec rails s
```
