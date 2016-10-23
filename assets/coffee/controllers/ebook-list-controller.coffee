module.exports = [
    '$scope', '$ionicHistory', 'navigation', 'modal', 'api', ($scope, $ionicHistory, navigation, modal, api) ->
        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.parseUrlToPara = (url) ->
            para = {}
            regexCatalogId = /page=([^&]*)/ig
            regexApply = /apply=([^&]*)/ig

            match = regexCatalogId.exec url
            if match
                para.catalog_id = match[1]
            match = regexApply.exec url
            if match
                para.apply = match[1]

            return para

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

        loadFavoriteEbooks = (page, perpage) ->
            modal.showLoading '', 'message.data_loading'

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.favorites = response.list
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log error
                console.log status_code

            api.getMyFavoriteEbooks(page, perpage, onSuccess, onError)


        $scope.$on('$ionicView.enter', (evt, data) ->
            loadCurrentEbook()
            loadCatalogEbooks(1, 5)
            loadFavoriteEbooks(1, 500)
        )
]