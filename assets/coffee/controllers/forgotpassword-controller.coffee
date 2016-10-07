module.exports = [
    '$rootScope', '$scope', '$state', 'navigation',
    ($rootScope, $scope, $state, navigation) ->
        $scope.goBack = () ->
            navigation.slide 'login', {}, 'down'
]