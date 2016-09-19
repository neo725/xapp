module.exports = [
    '$scope', '$cordovaToast', 'navigation', ($scope, $cordovaToast, navigation) ->
        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.wantRefunds = ($event) ->
            $event.stopPropagation()
            $cordovaToast.show('refund...', 'long', 'top')
]