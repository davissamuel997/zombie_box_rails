zombieBox.controller 'UsersController', ['$scope', '$http', 'UsersService', '$location', '$pusher', '$sce', ($scope, $http, UsersService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getUsers()

################################################################
############## Other Initializers ##############################


################################################################
################# Request Control ##############################

  $scope.requestControl = {

  	users: []

  	getUsers: ->
  		UsersService.getUsers.query({}, (responseData) ->
  			if responseData.errors == false
  				$scope.requestControl.users = responseData.users
  		)

  }

################################################################
################# Initialize ###################################

  init()


]
