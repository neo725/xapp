module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$state', 'navigation', 'modal',
    ($rootScope, $scope, $ionicHistory, $state, navigation, modal) ->
        $scope.shouldShowDelete = false
        $scope.pay = {}
        $scope.card = {}
        $scope.user = {}

        fake_card =
            number_part1: 5178
            number_part2: 1234
            number_part3: 1212
            number_part4: 4000
            expire_month: 8
            expire_year: 18
            cvc: 123
            holder: 'Neo'

        fake_user =
            username: 'Neo'
            gender: 'Male'
            email: 'thchang@sce.pccu.edu.tw'
            phone: '0986716086'
            userid: 'A123456789'

        $scope.card = fake_card
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
            $scope.items = []

        $scope.onItemDelete = (item) ->
            $scope.items.splice($scope.items.indexOf(item), 1)

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

            navigation.slide('home.member.cart.step3', {}, 'left')

        $scope.returnToDashboard = ->
            navigation.slide('home.dashboard', {}, 'right')

        checkIsCardAccept = ->
            return $scope.checkCardType not ''

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

        fakeCarts = [
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 1', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 2', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 3', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 4', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 5', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 6', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 7', Prod_Price: 1000, Shop_Id: 'MS' }
            { Prod_Id: '8X53_A5030', Prod_Name: '測試課程 8', Prod_Price: 1000, Shop_Id: 'MS' }
        ]

        $scope.carts = $rootScope.carts || fakeCarts

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

#         #content height adjust
#        document.addEventListener("deviceready", () ->
#            content_height = $('.view-container').height() - 335
#            console.log content_height
#            container = $('.content-container')
#            console.log container.height
#            container.height(content_height)
#        , false)
]