constants = require('../common/constants')

module.exports = [
    '$scope', '$ionicHistory', '$translate', '$timeout', 'modal', 'navigation', 'plugins', 'api',
    ($scope, $ionicHistory, $translate, $timeout, modal, navigation, plugins, api) ->

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.parseGPS = (gps) ->
            location = {}
            reg_gps_n = /N[+]?([-]?[0-9]*\.[0-9]+|[0-9]+)/g
            reg_gps_e = /E[+]?([-]?[0-9]*\.[0-9]+|[0-9]+)/g
            match = reg_gps_n.exec gps
            if match
                location.n = match[1]
            match = reg_gps_e.exec gps
            if match
                location.e = match[1]

            return "#{location.n},#{location.e}"

        $scope.goMap = (address, gps, location) ->
#            #$event.stopPropagation()
#            #console.log gps
#            # gps = N25.02583 E121.53812 >> chien-kuo
#            location = $scope.parseGPS(gps)
#
#            reg_address = /\([0-9]*\)[\s]?(.+)/g
#            match = reg_address.exec address
#            if match
#                location = match[1]
#
#            window.open("http://maps.google.com/?q=" + location, '_system')
            navigation.slide 'home.location-map', { location: location }, 'left'

        $scope.goPhoneCall = (number) ->
            window.open('tel:' + number, '_system')

        $scope.open = (phone) ->
            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    $scope.goPhoneCall(phone)
            params =
                phone_number: phone
            $translate(['title.location', 'message.current_is_on_duty', 'popup.ok', 'popup.cancel'], params).then (translator) ->
                plugins.notification.confirm(
                    translator['message.current_is_on_duty'],
                    confirmCallback,
                    translator['title.location'],
                    [translator['popup.ok'], translator['popup.cancel']]
                )

        $scope.closed = ->
            $translate(['title.location', 'message.current_is_off_duty', 'popup.ok']).then (translator) ->
                plugins.notification.confirm(
                    translator['message.current_is_off_duty'],
                    (->),
                    translator['title.location'],
                    [translator['popup.ok']]
                )

        $scope.getLocationItem = (name) ->
            return _.find(constants.LOCATIONS_MAPPING, { location_name: name })

        $scope.checkInTime = (times) ->
            return $scope.current_time > times.from and $scope.current_time < times.to

        toSeconds = (hour, minute, second) ->
            return (hour * 3600) + (minute * 60) + second

        parseTime = (value) ->
            reg_number = /(\d+)/g

            if value.match
                matches = value.match reg_number
                if matches && matches.length == 4
                    return {
                        from: toSeconds(parseInt(matches[0]), matches[1], 0)
                        to: toSeconds(parseInt(matches[2]), matches[3], 0)
                    }
            return {
                from: 0
                to: 0
            }

        loadLocation = ->
            today_weekday = moment(moment().valueOf()).locale("zh-TW").format("dd")
            console.log today_weekday

            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.locations = response.list

                _.forEach($scope.locations, (location) ->
                    #console.log location.name
                    #console.log location.openList
                    if location.openList
                        _.forEach(location.openList, (openItem) ->
                            mappingIndex = _.findIndex(constants.WEEKDAYS_MAPPING, { 'title': openItem.open_day })
                            if mappingIndex > -1
                                items = constants.WEEKDAYS_MAPPING[mappingIndex].weekdays
                                weekdayIndex = items.indexOf today_weekday
                                if weekdayIndex > -1
                                    #console.log openItem.open_time
                                    times = parseTime openItem.open_time
                                    #console.log times
                                    location.current_open_times = times
                        )
                )
            onError = () ->
                modal.hideLoading()

            api.getLocations(onSuccess, onError)

        tick = ->
            timeNow = new Date()
            hours   = timeNow.getHours()
            minutes = timeNow.getMinutes()
            seconds = timeNow.getSeconds()

            $scope.current_time = toSeconds hours, minutes, seconds

            $timeout tick, 1000

        tick()

        loadLocation()
]