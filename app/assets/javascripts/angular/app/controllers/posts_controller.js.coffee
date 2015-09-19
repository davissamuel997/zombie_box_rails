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

  	posts: []

  	getPosts: ->
  		PostsService.getPosts.query({}, (responseData) -> 
  			if responseData.errors == false
  				debugger
  		)

  }

################################################################
################# Initialize ###################################

  init()


]
