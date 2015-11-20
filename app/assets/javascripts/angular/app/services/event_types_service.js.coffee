collegeEvent.factory 'EventTypesService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  getEventTypes: $resource "/get_event_types.json", {}, query: { method: 'GET', isArray: false }

]