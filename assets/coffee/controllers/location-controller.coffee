module.exports = [
    '$scope', '$ionicHistory', 'modal', 'navigation', 'api', ($scope, $ionicHistory, modal, navigation, api) ->


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
            $event.stopPropagation()
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

        $scope.goPhoneCall = (number, $event) ->
            $event.stopPropagation()
            console.log number

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