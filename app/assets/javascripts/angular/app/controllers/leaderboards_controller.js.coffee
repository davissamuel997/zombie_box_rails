zombieBox.controller 'LeaderboardsController', ['$scope', '$http', 'UsersService', '$location', '$pusher', '$sce', ($scope, $http, UsersService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getLeaderboardData()

################################################################
############## Other Initializers ##############################

  $scope.sortableControl = {

    sortedBy: 'total_kills'

    total_kills: 'DESC'

    highest_round_reached: 'ASC'

    sortTotalKills: ->
      this.sortedBy = 'total_kills'
      if this.total_kills == 'DESC' then this.total_kills = 'ASC' else this.total_kills = 'DESC'
      $scope.requestControl.getLeaderboardData()

      this.highest_round_reached = 'ASC'

    sortHighestRoundReached: ->
      this.sortedBy = 'highest_round_reached'
      if this.highest_round_reached == 'DESC' then this.highest_round_reached = 'ASC' else this.highest_round_reached = 'DESC'
      $scope.requestControl.getLeaderboardData()

      this.total_kills = 'ASC'

    requestedSortBy: ->
      this.sortedBy

    requestedSortDirection: ->
      if this.sortedBy == 'total_kills'
        return this.total_kills
      else if this.sortedBy == 'highest_round_reached'
        return this.highest_round_reached
  }

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

      UsersService.getLeaderboardData.query({ page: this.current_page, sort_by: $scope.sortableControl.requestedSortBy(), sortable_direction: $scope.sortableControl.requestedSortDirection() }, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.users      = responseData.users
          $scope.requestControl.pagination = responseData.pagination

          if $scope.requestControl.users && $scope.requestControl.users.length > 0
            index = 0
            if $scope.sortableControl.requestedSortDirection() == "DESC"
              _($scope.requestControl.users.length).times ->
                rank = ((($scope.requestControl.current_page - 1) * 25) + index + 1)
                $scope.requestControl.users[index].rank = rank

                index += 1
            else
              total_pages = $scope.requestControl.pagination[1]
              total_users = $scope.requestControl.users.length
              rank = (total_pages * 25) - total_users - ((total_pages * 25) % total_users)
              index = 0

              _($scope.requestControl.users.length).times ->
                $scope.requestControl.users[index].rank = rank

                index += 1
                rank -= 1

          
        $scope.requestControl.isLoading = false
      )
  }

################################################################
################# Initialize ###################################

  init()


]
