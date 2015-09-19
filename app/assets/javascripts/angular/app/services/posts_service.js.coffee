zombieBox.factory 'PostsService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  resendAlert: $resource "/resend_alert.json", {}, query: { method: 'GET', isArray: false }

]