class @Sketch5 extends Sketch5
  @sendScheduledInstructions: ->
    console.log "Sending scheduled instructions."
    
    # Send new instructions to everyone on days 1–4 that have completed that day's sketch.
    usersCursor = User.documents.find
      currentDay:
        $lt: 5
      completedCurrentDay: true

    count = usersCursor.count()
    done = 0

    for user in usersCursor.fetch()
      @Sketch5.sendInstructions user, user.currentDay + 1
      done++

    console.log "Sent #{done}/#{count} instruction emails."
