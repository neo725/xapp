module.exports = [
    '$scope', '$ionicHistory', 'navigation', 'modal', 'api', ($scope, $ionicHistory, navigation, modal, api) ->
        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        loadCurrentEbook = () ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.ebooks = response.list
            onError = ->
                modal.hideLoading()

            api.getCurrentEbook(onSuccess, onError)

        $scope.$on('$ionicView.enter', (evt, data) ->
            loadCurrentEbook()
        )
]