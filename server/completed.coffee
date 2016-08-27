class @Sketch5 extends Sketch5
  @completed: (emailAddress, subject) ->
    return unless emailAddress
    
    # Update a user in the database setting their progress to the start.
    User.documents.update
      email: emailAddress
    ,
      $set:
        completedCurrentDay: true

    user = User.documents.findOne email: emailAddress

    unless user
      console.log "Can't do completed. User with email #{emailAddress} was not found."
      return

    textFilename = if user.currentDay is 5 then "Completed Course.txt" else "Completed Day.txt"
    text = Assets.getText textFilename
    paragraphs = text.split /\n{2,}/g

    emailComposer = new EmailComposer
    emailComposer.addParagraph paragraph for paragraph in paragraphs
    emailComposer.end()

    subject = "Re: #{subject}" unless subject.toLowerCase().indexOf('re:') is 0

    Email.send
      from: "Sketch5 <sketch5@retronator.com>"
      to: emailAddress
      subject: subject
      text: emailComposer.text
      html: emailComposer.html

    console.log "Completed email sent:", emailAddress, "day", user.currentDay
