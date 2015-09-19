zombieBox.factory 'PostsService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getPosts: $resource "/get_posts.json", {}, query: { method: 'GET', isArray: false }

]