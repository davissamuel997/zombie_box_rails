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

  	posts: []

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
