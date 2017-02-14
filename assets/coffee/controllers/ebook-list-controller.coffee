module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$translate', '$timeout', 'navigation', 'modal', 'plugins', 'api',
    ($rootScope, $scope, $ionicHistory, $translate, $timeout, navigation, modal, plugins, api) ->
        $scope.loading = false
        $scope.intro = {}
        $scope.favorites = []
        $scope.active = false

        $scope.goBack = () ->
            if not $scope.active
                return
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

        $scope.onItemDelete = (ebook) ->
            para = $scope.parseUrlToPara(ebook.web_url)

            modal.showLoading '', 'message.processing'

            onSuccess = (response) ->
                console.log response
                modal.hideLoading()
                $translate('message.success_to_delete_favorite_ebook').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
                index = _.findIndex($scope.favorites, { 'web_url': ebook.web_url })
                if index > -1
                    $scope.favorites.splice(index, 1)
            onError = () ->
                modal.hideLoading()

            api.deleteFavoriteEbook(para.apply, para.catalog_id, onSuccess, onError)

        loadEbookIntro = () ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.intro =
                    title: response.title
                    imgurl: response.imgurl
                    content: response.content
            onError = () ->
                modal.hideLoading()

            api.getEbookIntro(onSuccess, onError)

        loadCurrentEbook = () ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.ebooks = response.list
            onError = () ->
                modal.hideLoading()

            api.getCurrentEbooks(onSuccess, onError)

        loadCatalogEbooks = (page, perpage) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.catalogs = response.list
            onError = () ->
                modal.hideLoading()

            api.getCatalogEbooks(page, perpage, onSuccess, onError)

        loadFavoriteEbooks = (page, perpage) ->
            modal.showLoading '', 'message.data_loading'

            onSuccess = (response) ->
                $timeout ->
                    $scope.loading = false
                , 500
                modal.hideLoading()
                $scope.favorites = response.list

                $rootScope.ebook_favorites = _.map($scope.favorites, (item) ->
                    return {
                        yearmonth: item.yearmonth
                        catalog: item.catalog
                    }
                )

            onError = () ->
                modal.hideLoading()

            $scope.loading = true
            api.getMyFavoriteEbooks(page, perpage, onSuccess, onError)

        loadEbookIntro()
        loadCurrentEbook()
        loadCatalogEbooks(1, 5)
        $scope.$on('$ionicView.enter', ->
            loadFavoriteEbooks(1, 500)
        )
        $scope.$on('$ionicView.afterEnter', ->
            $timeout ->
                $scope.active = true
            , 1000
        )
        $scope.$on('$ionicView.leave', ->
            $scope.active = false
        )
]