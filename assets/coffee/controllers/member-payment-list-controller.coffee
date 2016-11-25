module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$timeout', 'navigation',
    ($rootScope, $scope, $ionicModal, $timeout, navigation) ->
        $scope.card = {}
        $scope.card.default = false
        $scope.show_card_list = false

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

        $scope.openNewCardBox = ->
            # modal darker
            $timeout(->
                $('.modal-backdrop-bg').removeClass('darker-backdrop-bg').addClass('darker-backdrop-bg')
            , 100)

            $scope.modalNewCard.show()

        $scope.toggleCardDefault = ->
            $scope.card.default = not $scope.card.default

        $scope.saveNewCard = ->
            $scope.show_card_list = true
            $scope.modalNewCard.hide()

        $scope.resetCardList = ->
            $scope.show_card_list = false

        $ionicModal.fromTemplateUrl('templates/modal-new-card.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalNewCard = modal
        )
]