zombieBox.controller 'PostsController', ['$scope', '$http', 'PostsService', '$location', '$pusher', '$sce', ($scope, $http, PostsService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    console.log("In the posts init")
    debugger

################################################################
############## Other Initializers ##############################


################################################################
################# Request Control ##############################

  $scope.requestControl = {

  }

################################################################
################# Initialize ###################################

  init()


]
