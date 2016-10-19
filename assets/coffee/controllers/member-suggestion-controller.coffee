module.exports = [
    '$scope', 'navigation',
    ($scope, navigation) ->

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'down'

]