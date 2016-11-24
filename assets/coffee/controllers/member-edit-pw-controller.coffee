module.exports = [
    '$scope', 'navigation',
    ($scope, navigation) ->
        $scope.goBack = () ->
            navigation.slide('home.member.edit', {}, 'down')

        $scope.goStep2 = ->
            navigation.slide 'home.member.edit-pw-2', {}, 'left'
]