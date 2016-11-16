constants = require('../common/constants')

module.exports = [
    '$scope', '$ionicSlideBoxDelegate', '$ionicModal', '$timeout', 'api', 'modal', 'navigation',
    ($scope, $ionicSlideBoxDelegate, $ionicModal, $timeout, api, modal, navigation) ->
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

        $scope.searchCourse = (keyword) ->
            navigation.slide 'home.course.search', {keyword: keyword}, 'left'

        # modal controller
        # ------------------------------------------------
        $scope.getWeekday = () ->
            weekdays = JSON.parse(window.localStorage.getItem('weekdays')) || []
            if weekdays.length == 0
                weekdays = constants.WEEKDAYS
            window.localStorage.setItem('weekdays', JSON.stringify(weekdays))
            weekdays = JSON.parse(window.localStorage.getItem('weekdays'))
            totalCount = 0
            totalCount += 1 if _.indexOf(weekdays, '一') != -1
            totalCount += 1 if _.indexOf(weekdays, '二') != -1
            totalCount += 1 if _.indexOf(weekdays, '三') != -1
            totalCount += 1 if _.indexOf(weekdays, '四') != -1
            totalCount += 1 if _.indexOf(weekdays, '五') != -1
            totalCount += 1 if _.indexOf(weekdays, '六') != -1
            totalCount += 1 if _.indexOf(weekdays, '日') != -1

            if totalCount == 7
                $scope.weekday = '時間不拘'
            else if totalCount > 3
                weekdays.splice(1, totalCount - 3)
                new_weekdays = []
                new_weekdays.push weekdays[0]
                new_weekdays.push '...'
                #new_weekdays.push weekdays[weekdays.length - 2]
                new_weekdays.push weekdays[weekdays.length - 1]
                $scope.weekday = _.join(new_weekdays, '，')
            else
                $scope.weekday = _.join(weekdays, '，')

        $scope.getWeekday()

        $scope.getLocation = () ->
            locations = JSON.parse(window.localStorage.getItem('locations')) || []
            if locations.length == 0
                locations = constants.LOCATIONS
            window.localStorage.setItem('locations', JSON.stringify(locations))
            locations = JSON.parse(window.localStorage.getItem('locations'))
            totalCount = 0
            totalCount += 1 if _.indexOf(locations, '建國') != -1
            totalCount += 1 if _.indexOf(locations, '忠孝') != -1
            totalCount += 1 if _.indexOf(locations, '延平') != -1
            totalCount += 1 if _.indexOf(locations, '大安') != -1
            totalCount += 1 if _.indexOf(locations, '台中') != -1
            totalCount += 1 if _.indexOf(locations, '高雄') != -1

            if totalCount == 6
                $scope.location = '地點不拘'
            else if totalCount > 2
                new_locations = []
                new_locations.push locations[0]
                #new_locations.push locations[1]
                new_locations.push '...'
                $scope.location = _.join(new_locations, '，')
            else
                $scope.location = _.join(location, '，')

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