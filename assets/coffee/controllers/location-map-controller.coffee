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

]