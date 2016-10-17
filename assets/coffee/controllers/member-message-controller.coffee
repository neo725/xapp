module.exports = [
    '$scope', '$ionicHistory', 'navigation', 'modal', 'api'
    ($scope, $ionicHistory, navigation, modal, api) ->

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

        # message type :
        # promo/course/order
#        $scope.message.img = 'img/membersbg@2x.jpg'

        loadMessageList = (perpage, type) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope['list_' + type] = response.list
            onError = ->
                modal.hideLoading()

            api.getMessageList(1, perpage, type, onSuccess, onError)

        loadMessageList(5, 'promo')
        loadMessageList(5, 'course')
        loadMessageList(5, 'order')
]