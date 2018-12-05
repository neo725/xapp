module.exports = [
    '$rootScope', '$scope', '$cordovaToast', '$translate', 'navigation', 'modal', 'api', 'plugins',
    ($rootScope, $scope, $cordovaToast, $translate, navigation, modal, api, plugins) ->
        $scope.loading_1 = false
        $scope.loading_2 = false
        $scope.loading_3 = false
        $scope.waiting_list = []
        $scope.payed_list = []
        $scope.refund_list = []

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.checkOrderStatus = (payway, status) ->
            # refund (目前關閉 我要退費狀態20181205)
            if status == 'refund' and payway == '信用卡付款-授權成功'
                return false
            if status == 'refund' and payway == 'ATM付款-付款完成'
                return false
            # cancel
            if status == 'cancel' and payway == 'ATM付款'
                return true
            if status == 'cancel' and payway == '信用卡付款'
                return true
            if status == 'cancel' and payway == 'ATM付款-款項入帳,待確認金額'
                return true
            # repay
            if status == 'repay' and payway == '未選擇付款方式'
                return true
            if status == 'repay' and payway == '信用卡付款-授權失敗'
                return true
            # info
            if status == 'info' and payway == 'ATM付款'
                return true
            if status == 'info' and payway == 'ATM付款-款項入帳,待確認金額'
                return true
            if status == 'info' and payway == 'ATM付款-付款完成'
                return true

            return false

        $scope.wantRePay = (index, order_no, details, $event) ->
            $event.stopPropagation()
            modal.showLoading '', 'message.processing'
            onSuccess = ->
                # addToOrderCart
                onSuccess = ->
                    modal.hideLoading()
                    # navigation
                    $rootScope.repay_order_no = order_no
                    navigation.slide 'home.member.order-cart.step1', {}, 'left'
                onError = () ->
                    modal.hideLoading()
                api.addToOrderCart 'MS', _.map(details, 'ProdId'), onSuccess, onError
            onError = () ->
                modal.hideLoading()
            api.clearFromOrderCart 'MS', onSuccess, onError

        $scope.wantPayInfo = (index, order_no, $event) ->
            $event.stopPropagation()
            navigation.slide 'home.member.order-info', { 'order_no': order_no }, 'left'

        $scope.wantRefunds = (index, order_no, $event) ->
            $event.stopPropagation()

            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    onSuccess = () ->
                        initLoad()
                    onError = (->)

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
                    onError = (->)

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

        loadOrders = (status, func) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                switch status
                    when '01' then $scope.waiting_list = response.list
                    when '02' then $scope.payed_list = response.list
                    when '03' then $scope.refund_list = response.list
                func()
            onError = () ->
                modal.hideLoading()
                func()

            api.getOrders(status, 1, 500, onSuccess, onError)

        initLoad = ->
            $scope.loading_1 = true
            $scope.loading_2 = true
            $scope.loading_3 = true

            loadDone = ->
                $scope.loading_1 = false
                $scope.loading_2 = false
                $scope.loading_3 = false
            loadOrders3 = ->
                loadOrders('03', loadDone)
            loadOrders2 = ->
                loadOrders('02', loadOrders3)

            loadOrders('01', loadOrders2)
            #loadOrders('02')
            #loadOrders('03')

            $scope.loading = false

        $scope.$on('$ionicView.enter', (evt, data) ->
            initLoad()
        )
]