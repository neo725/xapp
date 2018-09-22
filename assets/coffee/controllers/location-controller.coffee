constants = require('../common/constants')

module.exports = [
    '$scope', '$ionicHistory', '$translate', '$timeout', 'modal', 'navigation', 'plugins', 'api', 'CacheFactory', 'user',
    ($scope, $ionicHistory, $translate, $timeout, modal, navigation, plugins, api, CacheFactory, User) ->
        $scope.active = false

        if not CacheFactory.get('locationsCache')
            opts =
                maxAge: 24 * 60 * 60 * 1000
                deleteOnExpire: 'aggressive'
            CacheFactory.createCache('locationsCache', opts)
        locationsCache = CacheFactory.get('locationsCache')

        $scope.goBack = ->
            if not $scope.active
                return

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

        $scope.doRefresh = () ->
            if window.cache
                window.cache.clear()
            loadLocation(true)

        toSeconds = (hour, minute, second) ->
            return (hour * 3600) + (minute * 60) + second

        parseTime = (value) ->
            reg_number = /(\d+)/g

            if value.match
                matches = value.match reg_number
                if matches and matches.length == 4
                    return {
                        from: toSeconds(parseInt(matches[0]), matches[1], 0)
                        to: toSeconds(parseInt(matches[2]), matches[3], 0)
                    }
            return {
                from: 0
                to: 0
            }

        loadLocation = (forceReload) ->
            today_weekday = moment(moment().valueOf()).locale("zh-TW").format("dd")
            locations_all_in_cache = locationsCache.get('all')

            onSuccess = (response) ->
                $scope.$broadcast('scroll.refreshComplete')
                modal.hideLoading()
                $scope.locations = response.list

                _.forEach($scope.locations, (location) ->
                    if location.openList
                        _.forEach(location.openList, (openItem) ->
                            mappingIndex = _.findIndex(constants.WEEKDAYS_MAPPING, { 'title': openItem.open_day })
                            if mappingIndex > -1
                                items = constants.WEEKDAYS_MAPPING[mappingIndex].weekdays
                                weekdayIndex = items.indexOf today_weekday
                                if weekdayIndex > -1
                                    times = parseTime openItem.open_time
                                    location.current_open_times = times
                        )
                )

                locationsCache.put 'all', $scope.locations
            onError = () ->
                modal.hideLoading()

            if locations_all_in_cache and not forceReload
                $scope.locations = locations_all_in_cache
            else
                modal.showLoading('', 'message.data_loading')
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

        #User.getToken()

        $scope.$on('$ionicView.afterEnter', ->
            $timeout ->
                $scope.active = true
            , 1000
        )
        $scope.$on('$ionicView.leave', ->
            $scope.active = false
        )
]
