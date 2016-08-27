class @Sketch5 extends Sketch5
  @signUp: (email) ->
    return unless email
    
    # Insert or update a user in the database setting their progress to the start.
    User.documents.upsert
      email: email
    ,
      email: email

    user = User.documents.findOne email: email

    console.log "Signed up:", email

    # Send day 1 instructions straight away
    @sendInstructions user, 1

  @signUpMultiple: (emails) ->
    # When signing up multiple users, only do it for those that aren't signed up yet.
    for email in emails
      continue if email.indexOf('@') is -1
      email = email.trim()

      user = User.documents.findOne email: email
      continue if user

      @signUp email
