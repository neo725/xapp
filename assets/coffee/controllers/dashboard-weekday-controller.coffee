constants = require('../common/constants')

module.exports = ['$scope', ($scope) ->
        def_weekdays = constants.WEEKDAYS

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
        if _.indexOf(weekdays, def_weekdays[0]) > -1
            $scope.weekdays.monday = true
        if _.indexOf(weekdays, def_weekdays[1]) > -1
            $scope.weekdays.tuesday = true
        if _.indexOf(weekdays, def_weekdays[2]) > -1
            $scope.weekdays.wednesday = true
        if _.indexOf(weekdays, def_weekdays[3]) > -1
            $scope.weekdays.thursday = true
        if _.indexOf(weekdays, def_weekdays[4]) > -1
            $scope.weekdays.friday = true
        if _.indexOf(weekdays, def_weekdays[5]) > -1
            $scope.weekdays.saturday = true
        if _.indexOf(weekdays, def_weekdays[6]) > -1
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
            weekdays = []
            if $scope.weekdays.monday
                weekdays.push def_weekdays[0]
            if $scope.weekdays.tuesday
                weekdays.push def_weekdays[1]
            if $scope.weekdays.wednesday
                weekdays.push def_weekdays[2]
            if $scope.weekdays.thursday
                weekdays.push def_weekdays[3]
            if $scope.weekdays.friday
                weekdays.push def_weekdays[4]
            if $scope.weekdays.saturday
                weekdays.push def_weekdays[5]
            if $scope.weekdays.sunday
                weekdays.push def_weekdays[6]
            window.localStorage.setItem('weekdays', JSON.stringify(weekdays))
            $scope.$emit('weekdayConfirm')
            $scope.modalWeekday.hide()

        return
]