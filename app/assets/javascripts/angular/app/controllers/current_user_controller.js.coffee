zombieBox.controller 'CurrentUserController', ['$scope', '$http', 'CurrentUserService', '$location', '$pusher', '$sce', ($scope, $http, CurrentUserService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getUserDetails()

################################################################
############## Other Initializers ##############################

################################################################
################# Request Control ##############################

  $scope.loaderControl = {

    isLoading: false

  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    user: {}

    getUserDetails: ->
      CurrentUserService.getUserDetails.query({}, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.user = responseData.user
      )

  }

################################################################
################# Initialize ###################################

  init()


]
