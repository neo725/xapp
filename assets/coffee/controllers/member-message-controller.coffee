module.exports = [
    '$scope', '$ionicHistory', 'navigation',
    ($scope, $ionicHistory, navigation) ->

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')
]