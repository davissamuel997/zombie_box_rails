zombieBox.controller 'UsersController', ['$scope', '$http', 'UsersService', '$location', '$pusher', '$sce', ($scope, $http, UsersService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getCurrentUser()

################################################################
############## Other Initializers ##############################


################################################################
################# Request Control ##############################

  $scope.requestControl = {

    params: {}

    cancel: ->
      window.location = '/'

    getCurrentUser: ->
      UsersService.getCurrentUser.query({}, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.params = responseData.user
      )

    updateUser: ->
      if this.params.user_id && this.params.user_id > 0
        user_params = { first_name: this.params.first_name, last_name: this.params.last_name, email: this.params.email, phone_number: this.params.phone_number }

        UsersService.updateUser.query({ user_params: this.params, user_id: this.params.user_id }, (responseData) ->
          if responseData.errors == false
            gritterAdd("Successfully updated user.")

            window.location = '/'
        )
  }

################################################################
################# Initialize ###################################

  init()


]
