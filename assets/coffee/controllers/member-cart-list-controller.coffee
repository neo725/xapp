module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$state', '$timeout', '$translate', 'api', 'navigation', 'modal', 'plugins',
    ($rootScope, $scope, $ionicHistory, $state, $timeout, $translate, api, navigation, modal, plugins) ->
        $scope.carts = []
        $scope.shouldShowDelete = false
        $scope.pay = {}
        $scope.card = {}
        $scope.user = {}

#        fake_card =
#            number_part1: 5178
#            number_part2: 1234
#            number_part3: 1212
#            number_part4: 4000
#            expire_month: 8
#            expire_year: 18
#            cvc: 123
#            holder: 'Neo'

        fake_user =
            username: 'Neo'
            gender: 'Male'
            email: 'thchang@sce.pccu.edu.tw'
            phone: '0986716086'
            userid: 'A123456789'

#        $scope.card = fake_card
        $scope.user = fake_user

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.goStep2 = (pay_type) ->
            $scope.pay.type = pay_type
            navigation.slide('home.member.cart.step2', {}, 'left')

        $scope.goShowDelete = ->
            $scope.shouldShowDelete = not $scope.shouldShowDelete

        $scope.goClearAll = ->
            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    onSuccess = () ->
                        $timeout(
                            $scope.carts = []
                            $rootScope.carts = []
                        )
                    onError = () ->
                        modal.showLongMessage 'errors.request_failed'

                    api.clearFromCart 'MS', onSuccess, onError

            $translate(['title.clear_cart', 'message.clear_cart_confirm', 'popup.ok', 'popup.cancel']).then (translator) ->
                plugins.notification.confirm(
                    translator['message.clear_cart_confirm'],
                    confirmCallback,
                    translator['title.clear_cart'],
                    [translator['popup.ok'], translator['popup.cancel']]
                )

        $scope.onItemDelete = (item) ->
            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    onSuccess = () ->
                        $timeout(
                            $scope.carts.splice($scope.carts.indexOf(item), 1)
                        )
                    onError = () ->
                        modal.showLongMessage 'errors.request_failed'
                    api.removeFromCart 'MS', item.Prod_Id, onSuccess, onError
            params =
                item_name: item.Prod_Name

            $translate(['title.remove_item_from_cart', 'message.remove_item_from_cart_confirm',
                'popup.ok', 'popup.cancel'], params).then (translator) ->
                    plugins.notification.confirm(
                        translator['message.remove_item_from_cart_confirm'],
                        confirmCallback,
                        translator['title.remove_item_from_cart'],
                        [translator['popup.ok'], translator['popup.cancel']]
                    )

        $scope.checkPayTypeIsCreditCard = ->
            return $scope.pay.type == 'CreditCard'

        $scope.checkCardType = ->
            patternVisa = /^4\d{0,3}$/g
            patternMaster = /^5[1-5]\d{0,2}$/g
            number = $scope.card.number_part1
            if patternVisa.exec(number)
                return 'visa'
            if patternMaster.exec(number)
                return 'master'
            return ''

        $scope.submitForm = (form) ->
            pay_type = $scope.pay.type
            if not form.$valid
                modal.showLongMessage 'errors.form_validate_error'
                return
            if pay_type == 'CreditCard' and not checkIsCardAccept()
                modal.showLongMessage 'errors.credit_card_not_acceptable'
                return

            clearCart = (success) ->
                onSuccess = () ->
                    # clear cart if success
                    $scope.carts = []
                    $rootScope.carts = []

                    modal.hideLoading()
                    (success or (->))()

                onError = (error, status_code) ->
                    modal.hideLoading()
                    modal.showLongMessage 'errors.request_failed'

                api.clearFromCart 'MS', onSuccess, onError

            formatAccount = (account) ->
                return account.substr(0, 4) + '-' +
                        account.substr(4, 4) + '-' +
                        account.substr(8, 4) + '-' +
                        account.substr(12, 4)

            payByATM = (order_no, success, error) ->
                onSuccess = (response) ->
                    bank = {}
                    bank.no = response.bankNo
                    bank.account = formatAccount(response.account)
                    bank.amount = response.amount
                    $scope.bank = bank

                    (success || (->))()
                api.createATMPayment(order_no, onSuccess, error)

            collectCreditCardInfo = ->
                pad = (numeric, size) ->
                    str = '000' + numeric
                    return str.substr(str.length - size)

                getCardNumber = () ->
                    return pad($scope.card.number_part1, 4) +
                            pad($scope.card.number_part2, 4) +
                            pad($scope.card.number_part3, 4) +
                            pad($scope.card.number_part4, 4)

                getCardExpire = () ->
                    return pad($scope.card.expire_year + 2000, 4) +
                            pad($scope.card.expire_month, 2)
                card = {}
                card.number = getCardNumber()
                card.expire = getCardExpire()
                card.cvc = pad($scope.card.cvc, 3)

                return card

            payByCreditCard = (order_no, success, error) ->
                card = collectCreditCardInfo()

                api.createCreditCardPayment(order_no, card.number, card.expire, card.cvc, success, error)

            createPayment = (pay_type, order_no, success) ->
                error = ->
                    modal.hideLoading()
                    modal.showMessage('errors.payment_create_failed')

                if pay_type == 'ATM'
                    payByATM(order_no, success, error)

                if pay_type == 'CreditCard'
                    payByCreditCard(order_no, success, error)

            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    # create order
                    onSuccess = (response) ->
                        order_no = response.result
                        # pay_type = ATM or CreditCard
                        createPayment(pay_type, order_no, ->
                            modal.hideLoading()
#                            clearCart(->
#                                # go to step 3
#                                navigation.slide('home.member.cart.step3', {}, 'left')
#                            )
                            navigation.slide('home.member.cart.step3', {}, 'left')
                        )

                    onError = (error, status_code) ->
                        modal.hideLoading()
                        modal.showMessage 'errors.request_failed'

                    courses = _.map($scope.carts, 'Prod_Id')
                    courses = _.join(courses, ',')

                    modal.showLoading '', 'message.creating_order'
                    api.createOrder('MS', courses, onSuccess, onError)

            $translate(['title.submit_cart', 'message.submit_cart_confirm', 'popup.ok', 'popup.cancel']).then (translator) ->
                plugins.notification.confirm(
                    translator['message.submit_cart_confirm'],
                    confirmCallback,
                    translator['title.submit_cart'],
                    [translator['popup.ok'], translator['popup.cancel']]
                )

        $scope.returnToDashboard = ->
            navigation.slide('home.dashboard', {}, 'right')

        checkIsCardAccept = ->
            return '' != $scope.checkCardType()

        updateStepStatus = ->
            current_step = $state.current.url

            step = {
                s1:
                    current: current_step == '/1'
                    finish: current_step == '/2' or current_step == '/3'
                s2:
                    current: current_step == '/2'
                    finish: current_step == '/3'
                s3:
                    current: current_step == '/3'
                    finish: false
            }

            $scope.step = step

        watchCurrentUrl = ->
            return $state.current.url
        $scope.$watch watchCurrentUrl, updateStepStatus

        $scope.choice = 'CreditCard'

        loadCartList = () ->
            onSuccess = (response) ->
                $rootScope.carts = response.list
                $scope.carts = $rootScope.carts
                modal.hideLoading()
            onError = () ->
                modal.hideLoading()
            modal.showLoading('', 'message.data_loading')
            api.getCartList(1, 500, onSuccess, onError)

        updateTotalPrice = ->
            totalPrice = 0
            _($scope.carts).forEach (cart) ->
                totalPrice += cart.Prod_Price
            $scope.totalPrice = totalPrice

        watchCarts = ->
            return $scope.carts.length
        onCartsChanges = () ->
            updateTotalPrice()
        $scope.$watch watchCarts, onCartsChanges

        loadCartList()

        $scope.$on('$ionicView.enter', (evt, data) ->
            stateName = data.stateName
            cartIsEmpty = $scope.carts.length == 0

            if cartIsEmpty
                if stateName not in ['home.member.cart.step1', 'home.member.cart.step3']
                    navigation.slide('home.member.cart.step1', {}, 'right')
        )
]