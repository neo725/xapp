module.exports = [
    '$rootScope', '$scope', 'navigation',
    ($rootScope, $scope, navigation) ->

        card_list = []
        card_list.push({
            'card-number-4': '7552'
            'default': true
        })
        card_list.push({
            'card-number-4': '3526'
            'default': false
        })
        $scope.card_list = card_list

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'
]