module.exports = ['$rootScope', '$scope', '$stateParams', '$ionicHistory', 'api', 'navigation', 'modal', 'CacheFactory',
    ($rootScope, $scope, $stateParams, $ionicHistory, api, navigation, modal, CacheFactory) ->
        $scope.type = $stateParams.type
        groupId = $stateParams.group_id

        if not CacheFactory.get('messageCache')
            opts =
                storageMode: 'sessionStorage'
            CacheFactory.createCache('messageCache', opts)
        messageCache = CacheFactory.get('messageCache')

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        loadMessage = (groupId) ->
            loadMessage = (message) ->
                $scope.type = message.m_type
                $scope.messageTitle = message.m_title
                $scope.messageInfo = message.m_info

            onSuccess = (response) ->
                modal.hideLoading()
                loadMessage response
            onError = () ->
                modal.hideLoading()

            message_in_cache = messageCache.get "g-#{groupId}"
            if message_in_cache
                loadMessage message_in_cache
            else
                modal.showLoading('', 'message.data_loading')
                api.getMessage(groupId, onSuccess, onError)

        loadMessage(groupId)
]