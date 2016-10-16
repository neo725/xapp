module.exports = [
    '$scope', '$ionicHistory', 'navigation',
    ($scope, $ionicHistory, navigation) ->
        $scope.message = {}

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        # message type :
        # promo/course/order
        $scope.message.img = 'img/membersbg@2x.jpg'
]