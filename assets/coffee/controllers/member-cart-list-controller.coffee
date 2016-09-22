module.exports = [
    '$scope', '$ionicHistory', '$state', 'navigation', ($scope, $ionicHistory, $state, navigation) ->
        $scope.shouldShowDelete = false

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

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

        items = [
            { id: 1, price: 1000 }
            { id: 2, price: 1000 }
            { id: 3, price: 1000 }
            { id: 4, price: 1000 }
            { id: 5, price: 1000 }
            { id: 6, price: 1000 }
            { id: 7, price: 1000 }
            { id: 8, price: 1000 }
            { id: 9, price: 1000 }
            { id: 10, price: 1000 }
        ]
        $scope.items = items

        updateTotalPrice = ->
            totalPrice = 0
            _($scope.items).forEach (item) ->
                totalPrice += item.price
            $scope.totalPrice = totalPrice

        watchItems = ->
            return $scope.items.length
        onItemChanges = (newValue, oldValue) ->
            updateTotalPrice()
        $scope.$watch watchItems, onItemChanges

        # content height adjust
        document.addEventListener("deviceready", () ->
            content_height = $('.view-container').height() - 335
            console.log content_height
            container = $('.content-container')
            console.log container.height
            container.height(content_height)
        , false)
]