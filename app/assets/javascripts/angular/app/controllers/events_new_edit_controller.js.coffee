collegeEvent.controller 'EventsNewEditController', ['$scope', '$http', 'EventsService', '$location', '$pusher', '$sce', ($scope, $http, EventsService, $location, $pusher, $sce) ->

################################################################
############## Initial Page Load / Reset #######################

  init = ->
    $scope.requestControl.getActiveOrganizations()

################################################################
############## Other Initializers ##############################

###########################################################
################# Datepickers #############################

  $scope.datepicker = {

    dateOptions: {
      formatYear: 'yy',
      startingDay: 1,
      showWeeks: false
    };

    format: 'dd-MMMM-yyyy';

    minDate: new Date()

    opened: false

    clear: ->
      $scope.requestControl.params.date = null
    
    # Disable weekend selection
    disabled: (date, mode) ->
      return ( mode == 'day' && ( date.getDay() == 0 || date.getDay() == 6 ) );

    open: ($event) ->
      $event.preventDefault();
      $event.stopPropagation();

      if $scope.requestControl.params.date == null
        this.today()

      $scope.datepicker.opened = true;

    today: ->
      $scope.requestControl.params.date = new Date();

    toggleMin: ->
      $scope.minDate = $scope.minDate ? null : new Date();

  }

################################################################
################# Request Control ##############################

  $scope.loaderControl = {

    isLoading: false

  }

################################################################
################# Request Control ##############################

  $scope.requestControl = {

    eventStatuses: []

    eventTypes: []

    params: {

      address: null

      city: null

      date: null

      description: null

      end_time: null

      event_status_id: null

      event_type_id: null

      name: null

      organization_id: null

      postal_code: null

      start_time: null

      state: null

    }

    organizations: []

    states: []

    cancel: ->
      window.location = '/'

    createEvent: ->
      EventsService.createEvent.query({ event_params: this.params }, (responseData) ->
        if responseData.errors == false
          window.location = '/'
      )

    getActiveOrganizations: ->
      EventsService.getActiveOrganizations.query({}, (responseData) ->
        if responseData.errors == false
          $scope.requestControl.organizations = responseData.organizations
      )

    getEventDropdowns: ->
      if this.params.organization_id && this.params.organization_id > 0
        EventsService.getEventDropdowns.query({ organization_id: this.params.organization_id }, (responseData) ->
          if responseData.errors == false
            $scope.requestControl.eventStatuses = responseData.event_statuses
            $scope.requestControl.eventTypes    = responseData.event_types
            $scope.requestControl.states        = responseData.states
        )

  }

################################################################
################# Initialize ###################################

  init()


]
