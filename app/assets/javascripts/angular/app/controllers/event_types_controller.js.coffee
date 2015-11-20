collegeEvent.controller 'EventTypesController', ['$scope', '$http', 'EventTypesService', '$location', '$pusher', '$sce', ($scope, $http, EventTypesService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getEventTypes()

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

    event_types: []

    getEventTypes: ->
      EventTypesService.getEventTypes.query({}, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.event_types = responseData.event_types
      )

  }

################################################################
################# Initialize ###################################

  init()


]
