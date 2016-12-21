module.exports = ['$rootScope', '$scope', '$stateParams', '$ionicHistory', 'api', 'navigation',
    ($rootScope, $scope, $stateParams, $ionicHistory, api, navigation) ->
        $scope.type = $stateParams.type
        messageId = $stateParams.message_id

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        loadMessage = (messageId) ->
            onSuccess = (response) ->
                $scope.messageTitle = response.m_title
                $scope.messageInfo = response.m_info

            onError = (->)

            api.getMessage(messageId, onSuccess, onError)

        loadMessage(messageId)
]