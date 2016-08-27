class @User
  # email: the email address they signed up with.
  # currentDay: 1-5
  # completedCurrentDay: boolean indicating if the user has reported completion of their current day.
  @documents: new Mongo.Collection 'users',
    transform: (document) -> new User document

  constructor: (document) ->
    _.extend @, document
