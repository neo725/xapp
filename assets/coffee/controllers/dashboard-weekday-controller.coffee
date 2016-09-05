module.exports = ['$scope', '$log', ($scope, $log) ->
        $scope.weekdays = {
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            saturday: false,
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
            $scope.weekdays = {
                monday: val,
                tuesday: val,
                wednesday: val,
                thursday: val,
                friday: val,
                saturday: val,
                sunday: val
            }


        $scope.weekdayConfirmClick = () ->
            $log.info $scope.weekdays
            weekdays = []
            if $scope.weekdays.monday
                weekdays.push '一'
            if $scope.weekdays.tuesday
                weekdays.push '二'
            if $scope.weekdays.wednesday
                weekdays.push '三'
            if $scope.weekdays.thursday
                weekdays.push '四'
            if $scope.weekdays.friday
                weekdays.push '五'
            if $scope.weekdays.staturday
                weekdays.push '六'
            if $scope.weekdays.sunday
                weekdays.push '日'
            window.localStorage.setItem('weekdays', JSON.stringify(weekdays))
            $scope.$emit('weekdayConfirm')
            $scope.modalWeekday.hide()

        return
]