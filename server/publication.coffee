Meteor.publish "posts", (boardName) ->
  posts = posts.find()
  return posts;
  # or return multiple cursor iin array
  # [posts, comments]
