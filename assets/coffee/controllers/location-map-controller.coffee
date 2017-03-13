constants = require('../common/constants')

module.exports = [
    '$scope', '$ionicHistory', '$translate', '$timeout', '$stateParams', '$cordovaLaunchNavigator', 'modal', 'navigation', 'plugins', 'api',
    ($scope, $ionicHistory, $translate, $timeout, $stateParams, $cordovaLaunchNavigator, modal, navigation, plugins, api) ->

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.goNavigation = (item) ->
            if item
                $cordovaLaunchNavigator.navigate item.address, {}

        $scope.location = $stateParams.location

        $scope.item = _.find(constants.LOCATIONS_MAPPING, { location_name: $scope.location })

        latLng = new google.maps.LatLng($scope.item.latlng.n, $scope.item.latlng.e)

        initializeMap = ->
            mapOptions =
                center: latLng
                zoom: 15
                mapTypeId: google.maps.MapTypeId.ROADMAP
            $scope.map = new google.maps.Map(document.getElementById("map"), mapOptions)

            google.maps.event.addListenerOnce $scope.map, 'idle', ->
                new google.maps.Marker(
                    map: $scope.map
                    position: latLng
                )

        $timeout ->
            initializeMap()
]