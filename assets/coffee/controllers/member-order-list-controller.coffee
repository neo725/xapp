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

        $scope.formatDateTime = (datetime) ->
            return moment(datetime).format('YYYY/M/DD H:mm')

        loadOrders = (status) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                switch status
                    when '01' then $scope.payed_list = response.list
                    when '02' then $scope.waiting_list = response.list
                    when '03' then $scope.refund_list = response.list
            onError = ->
                modal.hideLoading()

            api.getOrders(status, 1, 500, onSuccess, onError)

        $scope.$on('$ionicView.enter', (evt, data) ->
            loadOrders('01')
            loadOrders('02')
            loadOrders('03')
        )
]