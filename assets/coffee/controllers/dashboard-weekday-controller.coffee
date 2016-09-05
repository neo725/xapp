module.exports = ['$scope', '$log', ($scope, $log) ->
        $scope.weekdays = {
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            staturday: false,
            sunday: false
        }
        weekdays = JSON.parse(window.localStorage.getItem('weekdays'))
        if _.indexOf(weekdays, '一') > -1
            $scope.weekdays.monday = true
        if _.indexOf(weekdays, '二') > -1
            $scope.weekdays.tuesday = true
        if _.indexOf(weekdays, '三') > -1
            $scope.weekdays.wednesday = true
        if _.indexOf(weekdays, '四') > -1
            $scope.weekdays.thursday = true
        if _.indexOf(weekdays, '五') > -1
            $scope.weekdays.friday = true
        if _.indexOf(weekdays, '六') > -1
            $scope.weekdays.saturday = true
        if _.indexOf(weekdays, '日') > -1
            $scope.weekdays.sunday = true
        $scope.everyday = true

        $scope.everydayClick = (val) ->
            $log.info val

        return
]