module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$state', 'navigation',
    ($rootScope, $scope, $ionicHistory, $state, navigation) ->
        $scope.shouldShowDelete = false

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.goStep2 = ->
            navigation.slide('home.member.cart.step2', {}, 'left')

        $scope.goShowDelete = ->
            $scope.shouldShowDelete = not $scope.shouldShowDelete

        $scope.goClearAll = ->
            $scope.items = []

        $scope.onItemDelete = (item) ->
            $scope.items.splice($scope.items.indexOf(item), 1)

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

        $scope.choice = 'CreditCard'

        $scope.carts = $rootScope.carts || []

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