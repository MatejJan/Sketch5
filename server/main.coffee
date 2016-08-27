multiparty = require 'multiparty'

Meteor.startup =>
  # Send scheduled instructions once a day.
   new Cron @Sketch5.sendScheduledInstructions,
     minute: 0
     hour: 3ß

WebApp.connectHandlers.use '/inbound', (request, response, next) =>

  form = new multiparty.Form()
  formParseSync = Meteor.wrapAsync form.parse.bind form

  # Handle multipart post request from SendGrid.
  fields = formParseSync request

  console.log "Received email from", fields.from

  # Parse email information.
  @Sketch5.parse fields

  # Return OK so SendGrid knows we've processed the request.
  response.writeHead 200
  response.end()
