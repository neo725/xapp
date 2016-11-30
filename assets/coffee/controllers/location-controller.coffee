module.exports = [
    '$scope', '$ionicHistory', '$translate', 'modal', 'navigation', 'plugins', 'api',
    ($scope, $ionicHistory, $translate, modal, navigation, plugins, api) ->


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

        $scope.goMap = (address, gps, $event) ->
            #$event.stopPropagation()
            #console.log gps
            # gps = N25.02583 E121.53812 >> chien-kuo
            location = $scope.parseGPS(gps)

            reg_address = /\([0-9]*\)[\s]?(.+)/g
            match = reg_address.exec address
            if match
                location = match[1]

            window.open("http://maps.google.com/?q=" + location, '_system')
            #console.log address
            #console.log location

        $scope.goPhoneCall = (number) ->
            window.open('tel:' + number, '_system')

        $scope.open = ->
            confirmCallback = ->
                $scope.goPhoneCall('886-2-2700-5858')

            $translate(['title.location', 'message.current_is_on_duty', 'popup.ok', 'popup.cancel']).then (translator) ->
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

        $scope.getOpenOrClosed = ($index) ->
            if $index == 1
                return false
            return true

        loadLocation = ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.locations = response.list
            onError = ->
                modal.hideLoading()

            api.getLocations(onSuccess, onError)

        loadLocation()
]