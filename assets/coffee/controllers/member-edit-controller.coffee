module.exports = [
    '$rootScope', '$scope', 'navigation', 'modal', 'api',
    ($rootScope, $scope, navigation, modal, api) ->
        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'
]