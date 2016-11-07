module.exports = [
    '$scope', '$cordovaToast', '$translate', 'navigation', 'modal', 'api', 'plugins',
    ($scope, $cordovaToast, $translate, navigation, modal, api, plugins) ->
        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.wantRefunds = (index, order_no, $event) ->
            $event.stopPropagation()

            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    onSuccess = () ->
                        initLoad()
                    onError = () ->
                        modal.showLongMessage 'errors.request_failed'

                    api.refundOrder order_no, onSuccess, onError

            $translate(['title.refund_order', 'message.refund_order_confirm', 'popup.ok', 'popup.cancel']).then (translator) ->
                plugins.notification.confirm(
                    translator['message.refund_order_confirm'],
                    confirmCallback,
                    translator['title.refund_order'],
                    [translator['popup.ok'], translator['popup.cancel']]
                )

        $scope.wantCancel = (index, order_no, $event) ->
            $event.stopPropagation()

            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    onSuccess = () ->
                        initLoad()
                    onError = () ->
                        modal.showLongMessage 'errors.request_failed'

                    api.cancelOrder order_no, onSuccess, onError

            $translate(['title.cancel_order', 'message.cancel_order_confirm', 'popup.ok', 'popup.cancel']).then (translator) ->
                plugins.notification.confirm(
                    translator['message.cancel_order_confirm'],
                    confirmCallback,
                    translator['title.cancel_order'],
                    [translator['popup.ok'], translator['popup.cancel']]
                )

        $scope.formatDateTime = (datetime) ->
            return moment(datetime).format('YYYY/M/DD H:mm')

        loadOrders = (status) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                switch status
                    when '01' then $scope.waiting_list = response.list
                    when '02' then $scope.payed_list = response.list
                    when '03' then $scope.refund_list = response.list
            onError = ->
                modal.hideLoading()

            api.getOrders(status, 1, 500, onSuccess, onError)

        initLoad = ->
            loadOrders('01')
            loadOrders('02')
            loadOrders('03')

        $scope.$on('$ionicView.enter', (evt, data) ->
            initLoad()
        )
]