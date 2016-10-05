constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicSlideBoxDelegate', '$log', 'api', 'modal',
    ($rootScope, $scope, $ionicSlideBoxDelegate, $log, api, modal) ->
        # angular svg round progressbar
        # repo : https://github.com/crisbeto/angular-svg-round-progressbar
        # demo : http://crisbeto.github.io/angular-svg-round-progressbar/
        $scope.current = 50
        $scope.radius = 43
        $scope.stroke = 4
        $scope.clockwise = false

        $scope.getDatePart = (date) ->
            return moment(date).format('YYYY/M/DD')

        $scope.getTimePart = (date) ->
            return moment(date).format('H:mm')

        $scope.getWeekdayName = (date) ->
            return constants.WEEKDAYS[moment(date).isoWeekday() - 1]

        $scope.getPercentage = (value) ->
            value *= 100
            return Math.floor(value)

        $scope.getLocationFullName = (value) ->
            item = _.find(constants.LOCATIONS_MAPPING, { name: value })
            if item
                return item['full_name']
            return value

        onSuccess = (response) ->
            list = response.list

            $scope.studyCards = list
            $scope.studyCardVisible = list.length > 0

            $ionicSlideBoxDelegate.update()

        onError = (response) ->
            $scope.studyCardVisible = false
            #modal.showMessage 'message.error'

        api.getStudyCards(onSuccess, onError)
]