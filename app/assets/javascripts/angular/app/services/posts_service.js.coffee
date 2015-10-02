zombieBox.factory 'PostsService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  createPost: $resource "/create_post.json", {}, query: { method: 'POST', isArray: false }

  createPostComment: $resource "/create_post_comment.json", {}, query: { method: 'POST', isArray: false }

  getPosts: $resource "/get_posts.json", {}, query: { method: 'GET', isArray: false }

  likePost: $resource "/like_post.json", {}, query: { method: 'GET', isArray: false }

  unLikePost: $resource "/unlike_post.json", {}, query: { method: 'GET', isArray: false }
]