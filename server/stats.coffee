Meteor.publish 'stats', ->
  stats =
    count: 0

  initializing = true

  usersHandle = User.documents.find().observeChanges
    added: =>
      stats.count++
      @changed 'stats', 0, stats unless initializing

    changed: =>

    removed: =>
      stats.count--
      @changed 'stats', 0, stats

  initializing = false
  @added 'stats', 0, stats
  @ready

  @onStop =>
    usersHandle.stop()
