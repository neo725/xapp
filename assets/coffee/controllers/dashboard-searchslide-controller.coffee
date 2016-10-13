constants = require('../common/constants')

module.exports = [
    '$scope', '$ionicSlideBoxDelegate', '$ionicModal', '$timeout', 'api', 'modal', 'navigation',
    ($scope, $ionicSlideBoxDelegate, $ionicModal, $timeout, api, modal, navigation) ->

        $scope.searchCourse = (keyword) ->
            navigation.slide 'home.course.search', {keyword: keyword}, 'left'

        onSuccess = (response) ->
            modal.hideLoading()
            list = response.list
            $scope.covers = list

            $timeout(->
                $('.search-slides').show()
                $ionicSlideBoxDelegate.update()
            , 1000)

        onError = (response) ->
            modal.hideLoading()
            modal.showMessage 'message.error'

        $('.search-slides').hide()
        modal.showLoading '', 'message.loading_cover'
        api.getCover(onSuccess, onError)

        $scope.getWeekday = () ->
            weekdays = JSON.parse(window.localStorage.getItem('weekdays')) || []
            if weekdays.length == 0
                weekdays = constants.WEEKDAYS
            window.localStorage.setItem('weekdays', JSON.stringify(weekdays))
            weekdays = JSON.parse(window.localStorage.getItem('weekdays'))
            $scope.weekday = _.join(weekdays, '，')

        $scope.getWeekday()

        $scope.getLocation = () ->
            locations = JSON.parse(window.localStorage.getItem('locations')) || []
            if locations.length == 0
                locations = constants.LOCATIONS
            window.localStorage.setItem('locations', JSON.stringify(locations))
            locations = JSON.parse(window.localStorage.getItem('locations'))
            $scope.location = _.join(locations, '，')

        $scope.getLocation()

        $ionicModal.fromTemplateUrl('templates/modal-weekday.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalWeekday = modal
        )

        $ionicModal.fromTemplateUrl('templates/modal-location.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalLocation = modal
        )

        # weekday modal controller
        # ------------------------------------------------
#        $scope.weekdayConfirmClick = () ->
#            $scope.modalWeekday.hide()
        $scope.$on('weekdayConfirm', () ->
            $scope.getWeekday()
        )

#        $scope.locationConfirmClick = () ->
#            $scope.modalLocation.hide()
        $scope.$on('locationConfirm', () ->
            $scope.getLocation()
        )
]