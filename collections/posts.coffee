@Posts = new Mongo.Collection "posts"



Posts.allow
  insert: (userId, doc) ->
    return true



  update: (userId, doc) ->
    return false



  remove: (userId, doc) ->
    return false
