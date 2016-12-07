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

        formatAccount = (account) ->
            return account.substr(0, 4) + '-' +
                    account.substr(4, 4) + '-' +
                    account.substr(8, 4) + '-' +
                    account.substr(12, 4)

        loadOrderInfo = (order_no) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.bank =
                    'account': formatAccount(response.account)
                    'amount': response.amount
            onError = (error, status_code) ->
                modal.hideLoading()

            api.getATMPaymentInfo order_no, onSuccess, onError

        loadOrderInfo order_no
]