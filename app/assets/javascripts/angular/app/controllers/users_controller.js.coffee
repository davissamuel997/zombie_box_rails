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

    requestFriend: (userId) ->
      if userId && userId > 0
        this.isLoading = true

        UsersService.requestFriend.query({ new_friend_user_id: userId, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.users      = responseData.users
            $scope.requestControl.pagination = responseData.pagination

            gritterAdd("Successfully added friend.")

          $scope.requestControl.isLoading = false
        )

  }

################################################################
################# Initialize ###################################

  init()


]
