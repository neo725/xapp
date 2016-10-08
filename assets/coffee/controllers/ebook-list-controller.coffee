module.exports = [
    '$scope', '$ionicHistory', 'navigation', 'api', ($scope, $ionicHistory, navigation, api) ->
        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')
]