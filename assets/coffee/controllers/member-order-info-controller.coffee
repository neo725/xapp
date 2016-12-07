module.exports = [
    '$scope', '$ionicHistory', '$stateParams', 'navigation', 'modal', 'api',
    ($scope, $ionicHistory, $stateParams, navigation, modal, api) ->
        $scope.bank = {}

        order_no = $stateParams.order_no

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        loadOrderInfo = (order_no) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.bank =
                    'account': response.account
                    'amount': response.amount
            onError = (error, status_code) ->
                modal.hideLoading()

            api.getATMPaymentInfo order_no, onSuccess, onError

        loadOrderInfo order_no
]