Router.configure
  layoutTemplate: 'layout'

Router.route '/',
  name: 'home',
  waitOn: ->
    Meteor.subscribe 'counties'
  action: ->
    @render 'home'
