module.exports = [
    '$scope', '$ionicHistory', 'navigation',
    ($scope, $ionicHistory, navigation) ->
        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'down')
            else
                navigation.slide('home.dashboard', {}, 'down')

        $scope.goStep2 = ->
            navigation.slide 'home.member.edit-pw-2', {}, 'left'
]