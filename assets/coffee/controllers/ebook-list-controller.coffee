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

            api.getCurrentEbooks(onSuccess, onError)

        loadCatalogEbooks = (page, perpage) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.catalogs = response.list
            onError = ->
                modal.hideLoading()

            api.getCatalogEbooks(page, perpage, onSuccess, onError)


        $scope.$on('$ionicView.enter', (evt, data) ->
            loadCurrentEbook()
            loadCatalogEbooks(1, 5)
        )
]