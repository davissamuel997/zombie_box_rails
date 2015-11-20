zombieBox.factory 'CurrentUserService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getUserDetails: $resource "/get_user_details.json", {}, query: { method: 'GET', isArray: false }

]