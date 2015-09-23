zombieBox.controller 'PostsController', ['$scope', '$http', 'PostsService', '$location', '$pusher', '$sce', ($scope, $http, PostsService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getPosts()

################################################################
############## Other Initializers ##############################


################################################################
################# Request Control ##############################

  $scope.requestControl = {

    pagination: null

    post_params: {

      text: null

      title: null

    }

    posts: []

    createPost: ->
      if this.post_params
        PostsService.createPost.query({ post_params: this.post_params }, (responseData) -> 
          debugger
        )

  	getPosts: ->
  		PostsService.getPosts.query({}, (responseData) -> 
  			if responseData.errors == false
  				$scope.requestControl.posts = responseData.posts
  				$scope.requestControl.pagination = responseData.pagination
  		)

  }

################################################################
################# Initialize ###################################

  init()


]
