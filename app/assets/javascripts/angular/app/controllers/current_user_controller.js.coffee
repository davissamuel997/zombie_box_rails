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

          # $scope.requestControl.makeTestRequest()
      )

    makeTestRequest: ->
      # user = { user_id: 1, total_points: 104, total_kills: 299, weapons: [{ weapon_id: 30, kill_count: 15, damage: 65, ammo: 99 }, { weapon_id: 32, kill_count: 15, damage: 100 }], skins: [{ skin_id: 64, kill_count: 345 }, { skin_id: 72, kill_count: 425 }] }

      user = {user_id: 1, total_points: 1000, total_kills:3000, weapons: [{ weapon_id: 30, kill_count: 15, damage: 65, ammo: 99 }], skins: [{ skin_id: 64, kill_count: 345 }]}

      CurrentUserService.makeTestRequest.query({ user_params: user }, (responseData) ->
        debugger
      )

  }

################################################################
################# Initialize ###################################

  init()


]
