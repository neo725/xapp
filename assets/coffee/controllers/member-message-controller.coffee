module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$cordovaBadge', '$log', 'navigation', 'modal', 'api'
    ($rootScope, $scope, $ionicHistory, $cordovaBadge, $log, navigation, modal, api) ->

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.formatDate = (dateValue) ->
            parsedDate = moment(dateValue,"YYYY-MM-DD")
            item = {}
            # year
            item.year = parsedDate.year()
            # date
            item.date = parsedDate.format("MM.DD")
            # weekday
            item.weekday = parsedDate.locale("en").format("ddd")

            return item

        $scope.goMessageInfo = (message) ->
            message.read_time = new Date()
            $rootScope.unread_message_count -= 1
            $cordovaBadge.set($rootScope.unread_message_count)

            params =
                'type': message.m_type
                'message_id': message.messageId
            navigation.slide 'home.member.message-info', params, 'left'

        $scope.toggleVisible = (type) ->
            count = $scope["#{type}_count"]

            if count <= 5
                count = $scope["list_#{type}"].length
            else
                count = 5

            $scope["#{type}_count"] = count

        # message type :
        # promo/course/order

        loadMessageList = (perpage, type) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope["list_#{type}"] = response.list
                if response.list.length < 5
                    $scope["#{type}_count"] = response.list.length
                else
                    $scope["#{type}_count"] = 5
            onError = () ->
                modal.hideLoading()

            api.getMessageList(1, perpage, type, onSuccess, onError)

        loadMessageList 500, 'promo'
        loadMessageList 500, 'course'
        loadMessageList 500, 'order'
]