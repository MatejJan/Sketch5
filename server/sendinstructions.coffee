class @Sketch5 extends Sketch5
  @sendInstructions: (user, day) ->
    console.log "Sending day #{day} instructions to", user.email

    text = Assets.getText "Day #{day}.txt"
    paragraphs = text.split /\n{2,}/g

    imageBuffer = Assets.getBinary "Day #{day}.jpg"
    imageContentId = "#{Date.now()}.image.jpg"

    email = new EmailComposer
    email.addParagraph paragraph for paragraph in paragraphs
    email.addImage imageContentId
    email.end()

    Email.send
      from: "Sketch5 <sketch5@retronator.com>"
      to: user.email
      subject: "Sketch5 — Day #{day}"
      text: email.text
      html: email.html
      attachments: [
        filename:"Sketch5 Day #{day}.jpg"
        contents: imageBuffer
        contentType: 'image/jpeg'
        cid: imageContentId
      ]

    User.documents.update user._id,
      $set:
        currentDay: day
        completedCurrentDay: false
