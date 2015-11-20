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

    current_page: 1

    isLoading: false

    pagination: null

    users: []

    changePage: (page_number) ->
      this.current_page = page_number

      this.getUsers()

  	getUsers: ->
      this.isLoading = true

      UsersService.getUsers.query({ page: this.current_page }, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.users      = responseData.users
          $scope.requestControl.pagination = responseData.pagination

        $scope.requestControl.isLoading = false
      )

  }

################################################################
################# Initialize ###################################

  init()


]
