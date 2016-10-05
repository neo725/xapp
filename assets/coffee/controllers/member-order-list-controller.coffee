module.exports = [
    '$scope', '$cordovaToast', 'navigation', 'modal', 'api',
    ($scope, $cordovaToast, navigation, modal, api) ->
        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.wantRefunds = ($event) ->
            $event.stopPropagation()
            $cordovaToast.show('refund...', 'long', 'top')

        $scope.wantCancel = ($event) ->
            $event.stopPropagation()
            $cordovaToast.show('cancel...', 'long', 'top')

        loadOrders = (status) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                switch status
                    when '10' then $scope.payed_list = response.list
                    when '20' then $scope.waiting_list = response.list
                    when '30' then $scope.refund_list = response.list
            onError = ->
                modal.hideLoading()

            api.getOrders(status, 1, 500, onSuccess, onError)

        $scope.$on('$ionicView.enter', (evt, data) ->
            loadOrders('10')
            loadOrders('20')
            loadOrders('30')
        )
]