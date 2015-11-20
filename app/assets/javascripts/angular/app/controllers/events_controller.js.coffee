collegeEvent.controller 'EventsController', ['$scope', '$http', 'EventsService', '$location', '$pusher', '$sce', ($scope, $http, EventsService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getEvents()

################################################################
############## Other Initializers ##############################

################################################################
################# Request Control ##############################

  $scope.loaderControl = {

    isLoading: false

  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    events: []

    newComment: null

    scopedEventIndex: null

    createEventComment: (eventIndex) ->
      this.scopedEventIndex = eventIndex

      event = this.events[this.scopedEventIndex]

      if this.newComment && this.newComment.length > 0 && event.event_id && event.event_id > 0
        EventsService.createEventComment.query({ event_id: event.event_id, comment_text: this.newComment, rating: this.rating }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.events[$scope.requestControl.scopedEventIndex].comments = responseData.comments

            $scope.requestControl.scopedEventIndex = null

            $scope.requestControl.newComment = null
            $scope.requestControl.rating = null  
        )

    getEvents: ->
      EventsService.getEvents.query({}, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.events = responseData.events
      )

  }

################################################################
################# Initialize ###################################

  init()


]
