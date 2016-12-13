module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$timeout', '$translate', '$ionicListDelegate', 'navigation', 'util', 'plugins',
    ($rootScope, $scope, $ionicModal, $timeout, $translate, $ionicListDelegate, navigation, util, plugins) ->
        $scope.card = {}
        $scope.pay_list_title = ''

        card_list_name = 'card_list'

#        card_list = []
#        card_list.push({
#            'card-number-4': '7552'
#            'default': true
#        })
#        card_list.push({
#            'card-number-4': '3526'
#            'default': false
#        })
#        $scope.card_list = card_list


        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.checkCardType = (number) ->
            return util.checkCardType(number)

        $scope.openNewCardBox = () ->
            $scope.card = {}

            # modal darker
            $timeout(->
                $('.modal-backdrop-bg').removeClass('darker-backdrop-bg').addClass('darker-backdrop-bg')
            , 100)

            $scope.modalNewCard.show()

        $scope.onItemDelete = (card) ->
            index = _.findIndex($scope.card_list, (item) ->
                isMatch = item.number_part1 == card.number_part1
                isMatch &= item.number_part2 == card.number_part2
                isMatch &= item.number_part3 == card.number_part3
                isMatch &= item.number_part4 == card.number_part4

                return isMatch
            )
            if index > -1
                card = $scope.card_list[index]
                $scope.card_list.splice(index, 1)
                updateStorage()
                if card.default
                    window.localStorage.removeItem 'saved_card'

            $ionicListDelegate.closeOptionButtons()

        $scope.submitForm = (form) ->
            $scope.form = form
            if not form.$valid
                $translate(['title.payment_list', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.payment_list'],
                        translator['popup.ok']
                    )
                return

            if $scope.checkCardType($scope.card.number_part1) == ''
                $translate(['title.payment_list', 'errors.credit_card_not_acceptable', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.credit_card_not_acceptable'],
                        (->),
                        translator['title.payment_list'],
                        translator['popup.ok']
                    )
                return

            if checkCardExists($scope.card)
                $translate(['title.payment_list', 'errors.credit_card_exists', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.credit_card_exists'],
                        (->),
                        translator['title.payment_list'],
                        translator['popup.ok']
                    )
                return

            $scope.card.default = false
            if $scope.card_list.length == 0
                $scope.card.default = true

            $scope.card_list.push $scope.card
            updateStorage()
            if $scope.card.default
                saveDefaultCard $scope.card

            $scope.modalNewCard.hide()

        $scope.checkCardListIsEmpty = ->
            return $scope.card_list.length == 0

        $scope.toggleDefaultCard = (card) ->
            _.forEach($scope.card_list, (currentCard) ->
                isMatch = card.number_part4 == currentCard.number_part4
                isMatch &= card.expire_month == currentCard.expire_month
                isMatch &= card.expire_year == currentCard.expire_year

                currentCard.default = isMatch

                if isMatch
                    saveDefaultCard currentCard
            )

        saveDefaultCard = (card) ->
            saved_card = {
                'card': card
            }
            window.localStorage.setItem 'saved_card', JSON.stringify(saved_card)

        checkCardExists = (card) ->
            matchExists = false
            _.forEach($scope.card_list, (currentCard) ->
                isMatch = card.number_part1 == currentCard.number_part1
                isMatch &= card.number_part2 == currentCard.number_part2
                isMatch &= card.number_part3 == currentCard.number_part3
                isMatch &= card.number_part4 == currentCard.number_part4

                matchExists |= isMatch
            )

            return matchExists

        updateStorage = ->
            window.localStorage.setItem card_list_name, JSON.stringify($scope.card_list)

        loadCardList = ->
            cards = JSON.parse(window.localStorage.getItem(card_list_name)) || []
            $scope.card_list = cards
            $scope.pay_list_title = ''

        loadCardList()

        $scope.$watch ->
                return $scope.card_list.length
            , (value) ->
                params =
                    count: value
                $translate(['text.pay_list_title'], params).then (translation) ->
                    $scope.pay_list_title = translation['text.pay_list_title']

        $ionicModal.fromTemplateUrl('templates/modal-new-card.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalNewCard = modal
        )

        $scope.$on('modal.shown', ->
            if $scope.form
                $scope.form.$setPristine()
                $scope.form.$setUntouched()
        )
]