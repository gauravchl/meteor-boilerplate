# Docs: http://iron-meteor.github.io/iron-router/

Router.route '/',
  layoutTemplate: 'empty_layout'


# Route Specific Options
###
Router.route '/post/:_id',
  # The name of the route.
  # Used to reference the route in path helpers and to find a default template
  # for the route if none is provided in the "template" option. If no name is
  # provided, the router guesses a name based on the path '/post/:_id'
  name: 'post.show'

  # To support legacy versions of Iron.Router you can provide an explicit path
  # as an option, in case the first parameter is actually a route name.
  # However, it is recommended to provide the path as the first parameter of the
  # route function.
  path: '/post/:_id'

  # If we want to provide a specific RouteController instead of an anonymous
  # one we can do that here. See the Route Controller section for more info.
  controller: 'CustomController'

  # If the template name is different from the route name you can specify it
  # explicitly here.
  template: 'Post'

  # A layout template to be used with this route.
  # If there is no layout provided, a default layout will
  # be used.
  layoutTemplate: 'ApplicationLayout'

  # A declarative way of providing templates for each yield region
  # in the layout
  yieldRegions:
    'MyAside': {to: 'aside'},
    'MyFooter': {to: 'footer'}


  # a place to put your subscriptions
  subscriptions: ->
    @subscribe('items')

    # add the subscription to the waitlist
    @subscribe('item', this.params._id).wait()


  # Subscriptions or other things we want to "wait" on. This also
  # automatically uses the loading hook. That's the only difference between
  # this option and the subscriptions option above.
  waitOn: ->
    return Meteor.subscribe('post', this.params._id)


  # A data function that can be used to automatically set the data context for
  # our layout. This function can also be used by hooks and plugins. For
  # example, the "dataNotFound" plugin calls this function to see if it
  # returns a null value, and if so, renders the not found template.
  data: ->
    return Posts.findOne({_id: this.params._id})


  # You can provide any of the hook options described below in the "Using
  # Hooks" section.
  onRun: ->
  onRerun: ->
  onBeforeAction: ->
  onAfterAction: ->
  onStop: ->

  # The same thing as providing a function as the second parameter. You can
  # also provide a string action name here which will be looked up on a Controller
  # when the route runs. More on Controllers later. Note, the action function
  # is optional. By default a route will render its template, layout and
  # regions automatically.
  # Example:
  #  action: 'myActionFunction'
  action: ->
    # render all templates and regions for this route
    this.render()
###

###
# Subscriptions

##Technique one:
Router.route '/post/:_id',
  subscriptions: ->
    // returning a subscription handle or an array of subscription handles
    // adds them to the wait list.
    return Meteor.subscribe('item', this.params._id)


  action: ->
    if this.ready()
      this.render()
    else
      this.render('Loading')

##Technique two:
Router.route '/post/:_id',
  # this template will be rendered until the subscriptions are ready
  loadingTemplate: 'loading'

  waitOn: ->
    # return one handle, a function, or an array
    return Meteor.subscribe('post', this.params._id)

  action: ->
    this.render('myTemplate')

###

Router.route '/(.*)',
  layoutTemplate: 'empty_layout'

