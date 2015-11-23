zombieBox.controller 'UsersController', ['$scope', '$http', 'UsersService', '$location', '$pusher', '$sce', ($scope, $http, UsersService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getUsers()

################################################################
############## Other Initializers ##############################

  $scope.searchControl = {
    filteredEmail: ->
      angular.lowercase($scope.searchInput.email)

    filteredFullName: ->
      angular.lowercase($scope.searchInput.full_name)

    filteredPhoneNumber: ->
      $scope.searchInput.phone_number
  }

  $scope.searchInput = {
    email: null

    full_name: null

    phone_number: null
  }

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

      UsersService.getUsers.query({ page: this.current_page, full_name: $scope.searchControl.filteredFullName(), email: $scope.searchControl.filteredEmail(), phone_number: $scope.searchControl.filteredPhoneNumber() }, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.users      = responseData.users
          $scope.requestControl.pagination = responseData.pagination

        $scope.requestControl.isLoading = false
      )

    removeFriend: (userId) ->
      if userId && userId > 0
        this.isLoading = true

        UsersService.removeFriend.query({ remove_friend_user_id: userId, page: this.current_page }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.users      = responseData.users
            $scope.requestControl.pagination = responseData.pagination

            gritterAdd("Successfully remove friend.")

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

    resetSearch: ->
      $scope.searchInput.email        = null
      $scope.searchInput.full_name    = null
      $scope.searchInput.phone_number = null

      this.changePage(1)

    searchUsers: ->
      this.changePage(1)

  }

################################################################
################# Initialize ###################################

  init()


]
