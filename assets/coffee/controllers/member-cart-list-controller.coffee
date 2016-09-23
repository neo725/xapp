module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$state', 'navigation', 'modal',
    ($rootScope, $scope, $ionicHistory, $state, navigation, modal) ->
        $scope.shouldShowDelete = false
        $scope.pay = {}

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.goStep2 = ->
            $scope.pay.type = $scope.choice
            navigation.slide('home.member.cart.step2', {}, 'left')

        $scope.goShowDelete = ->
            $scope.shouldShowDelete = not $scope.shouldShowDelete

        $scope.goClearAll = ->
            $scope.items = []

        $scope.onItemDelete = (item) ->
            $scope.items.splice($scope.items.indexOf(item), 1)

        $scope.checkPayTypeIsCreditCard = ->
            return $scope.pay.type == 'CreditCard'

        $scope.submitForm = (form) ->
            pay_type = $scope.pay.type
            if not form.$valid
                modal.showLongMessage 'errors.form_validate_error'
                return

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

        # content height adjust
        document.addEventListener("deviceready", () ->
            content_height = $('.view-container').height() - 335
            console.log content_height
            container = $('.content-container')
            console.log container.height
            container.height(content_height)
        , false)
]