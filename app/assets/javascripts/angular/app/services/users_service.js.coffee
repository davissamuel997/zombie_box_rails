zombieBox.factory 'UsersService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getCurrentUser: $resource "/get_current_user.json", {}, query: { method: 'GET', isArray: false }

  getLeaderboardData: $resource "/get_leaderboard_data.json", {}, query: { method: 'GET', isArray: false }

  getUsers: $resource "/get_users.json", {}, query: { method: 'GET', isArray: false }

  removeFriend: $resource "/remove_friend.json", {}, query: { method: 'GET', isArray: false }

  requestFriend: $resource "/request_friend.json", {}, query: { method: 'GET', isArray: false }

  updateUser: $resource "/update_user.json", {}, query: { method: 'POST', isArray: false }

]