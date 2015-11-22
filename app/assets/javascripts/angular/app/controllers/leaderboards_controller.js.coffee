zombieBox.controller 'LeaderboardsController', ['$scope', '$http', 'UsersService', '$location', '$pusher', '$sce', ($scope, $http, UsersService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getLeaderboardData()

################################################################
############## Other Initializers ##############################

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    current_page: 1

    isLoading: false

    pagination: null

    user: []

    changePage: (page_number) ->
      this.current_page = page_number
      this.getLeaderboardData()

    getLeaderboardData: ->
      this.isLoading = true

      UsersService.getLeaderboardData.query({ page: this.current_page }, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.users      = responseData.users
          $scope.requestControl.pagination = responseData.pagination

          if $scope.requestControl.users && $scope.requestControl.users.length > 0
            index = 0
            _($scope.requestControl.users.length).times ->
              rank = ((($scope.requestControl.current_page - 1) * 25) + index + 1)
              $scope.requestControl.users[index].rank = rank

              index += 1

          
        $scope.requestControl.isLoading = false
      )
  }

################################################################
################# Initialize ###################################

  init()


]
