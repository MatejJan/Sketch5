{Template} = require 'meteor/templating'
{ReactiveVar} = require 'meteor/reactive-var'

require './main.html'

stats = new Mongo.Collection 'stats'

Template.stats.onCreated ->
  @_statsHandle = Meteor.subscribe 'stats'

Template.stats.onDestroyed ->
  @_statsHandle.stop()

Template.stats.helpers
  stats: ->
    stats.findOne()
