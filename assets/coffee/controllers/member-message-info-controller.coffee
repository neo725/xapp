module.exports = ['$rootScope', '$scope', '$stateParams', '$ionicHistory', 'api', 'navigation', 'modal',
    ($rootScope, $scope, $stateParams, $ionicHistory, api, navigation, modal) ->
        $scope.type = $stateParams.type
        messageId = $stateParams.message_id

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        loadMessage = (messageId) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()

                $scope.messageTitle = response.m_title
                $scope.messageInfo = response.m_info

            onError = () ->
                modal.hideLoading()

            api.getMessage(messageId, onSuccess, onError)

        loadMessage(messageId)
]