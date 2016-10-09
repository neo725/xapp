module.exports = [
    '$scope', '$stateParams', '$ionicHistory', '$sce', 'navigation', 'modal', 'api',
    ($scope, $stateParams, $ionicHistory, $sce, navigation, modal, api) ->
        yearmonth = $stateParams.yearmonth
        catalog_id = $stateParams.catalog_id

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.addToFavorite = (ebook) ->
            console.log yearmonth
            console.log catalog_id

        loadCatalogEbook = (yearmonth, catalog_id) ->
            modal.showLoading '', 'message.data_loading'

            onSuccess = (response) ->
                $scope.ebook = response

                $scope.ebook.safe_intro = $sce.trustAsHtml($scope.ebook.intro)
                $scope.ebook.safe_context = $sce.trustAsHtml($scope.ebook.context)
                modal.hideLoading()
            onError = ->
                modal.hideLoading()

            api.getCatalogEbook yearmonth, catalog_id, onSuccess, onError

        $scope.$on('$ionicView.enter', (evt, data) ->
            loadCatalogEbook(yearmonth, catalog_id)
        )
]