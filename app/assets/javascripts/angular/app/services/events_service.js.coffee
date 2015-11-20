collegeEvent.factory 'EventsService', ['$resource', '$q', '$http', ($resource, $q, $http) ->

  createEvent: $resource "/create_event.json", {}, query: { method: 'GET', isArray: false }

  createEventComment: $resource "/create_event_comment.json", {}, query: { method: 'GET', isArray: false }

  getActiveOrganizations: $resource "/get_active_organizations.json", {}, query: { method: 'GET', isArray: false }

  getEventDropdowns: $resource "/get_event_dropdowns.json", {}, query: { method: 'GET', isArray: false }

  getEvents: $resource "/get_events.json", {}, query: { method: 'GET', isArray: false }

]