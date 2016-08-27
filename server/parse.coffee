class @Sketch5 extends Sketch5
  @parse: (fields) ->
    email = @_parseEmail fields
    subject = fields.subject?[0].toLowerCase() or ''
    text = fields.text?[0].toLowerCase() or ''
    lines = text.split /\r?\n/
    firstLine = lines[0] or ''

    # Process commands in order of priority
    processMethods = [
      @_processAdminDone
      @_processAdmin
      @_processSignUp
      @_processCompleted
    ]

    for method in processMethods
      processed = method email, subject, firstLine, lines, text
      return if processed
     
  @_parseEmail: (fields) ->
    email = fields.from[0].match(/<(\S*)>/)?[1]

    unless email or fields.from[0].indexOf('@') is -1
      email = fields.from[0].trim()

    console.log "Parsed email:", email

    throw new Error 'argument-error', "Email was not extracted correctly from #{fields.from}" unless email
    
    email.toLowerCase()

  @_findCommand: (subject, firstLine, command) ->
    (subject.indexOf(command) > -1 and subject.indexOf('re:') is -1) or (firstLine.indexOf(command) > -1)

  @_processSignUp: (email, subject, firstLine) ->
    # Detect sign up.
    return unless @Sketch5._findCommand subject, firstLine, 'sign up'

    @Sketch5.signUp email

    true

  @_processCompleted: (email, subject, firstLine) ->
    # Detect done.
    return unless @Sketch5._findCommand subject, firstLine, 'done'
    
    @Sketch5.completed email, subject

    true
  
  @_processAdminDone: (email, subject, firstLine, lines) ->
    # Detect admin password in subject.
    adminPassword = Meteor.settings.adminPassword
    return unless @Sketch5._findCommand subject, firstLine, 'done'
    return unless @Sketch5._findCommand subject, firstLine, adminPassword

    @Sketch5.completed email, subject for email in lines

    true

  @_processAdmin: (email, subject, firstLine, lines) ->
    # Detect admin password in subject.
    adminPassword = Meteor.settings.adminPassword
    return unless @Sketch5._findCommand subject, firstLine, adminPassword

    @Sketch5.signUpMultiple lines

    true
