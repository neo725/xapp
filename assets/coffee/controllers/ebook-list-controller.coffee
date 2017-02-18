module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$translate', '$timeout', 'navigation', 'modal', 'plugins', 'api', 'CacheFactory',
    ($rootScope, $scope, $ionicHistory, $translate, $timeout, navigation, modal, plugins, api, CacheFactory) ->
        $scope.loading = true
        $scope.intro = {}
        $scope.favorites = []
        $scope.active = false

        if not CacheFactory.get('ebooksCache')
            CacheFactory.createCache('ebooksCache')
        ebooksCache = CacheFactory.get('ebooksCache')

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
                #console.log response
                modal.hideLoading()
                $translate('message.success_to_delete_favorite_ebook').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
                index = _.findIndex($scope.favorites, { 'web_url': ebook.web_url })
                if index > -1
                    $scope.favorites.splice(index, 1)
            onError = () ->
                modal.hideLoading()

            api.deleteFavoriteEbook(para.apply, para.catalog_id, onSuccess, onError)

        $scope.doRefreshCurrent = () ->
            loadEbookIntro(true)
            loadCurrentEbooks(true)

        $scope.doRefreshCatalog = () ->
            loadCatalogEbooks(1, 5, true)

        $scope.doRefreshFavorite = () ->
            loadFavoriteEbooks(1, 500, true)

        loadEbookIntro = (forceReload) ->
            ebooks_intro_in_cache = ebooksCache.get('intro')

            onSuccess = (response) ->
                modal.hideLoading()
                ebooksCache.put 'intro', response
                $scope.intro =
                    title: response.title
                    imgurl: response.imgurl
                    content: response.content
            onError = () ->
                modal.hideLoading()

            if ebooks_intro_in_cache and not forceReload
                $scope.intro = ebooks_intro_in_cache
            else
                modal.showLoading('', 'message.data_loading')
                api.getEbookIntro(onSuccess, onError)

        loadCurrentEbooks = (forceReload) ->
            ebooks_current_in_cache = ebooksCache.get('current')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.$broadcast('scroll.refreshComplete')
                ebooksCache.put 'current', response.list
                $scope.ebooks = response.list
            onError = () ->
                modal.hideLoading()

            if ebooks_current_in_cache and not forceReload
                $scope.ebooks = ebooks_current_in_cache
            else
                modal.showLoading('', 'message.data_loading')
                api.getCurrentEbooks(onSuccess, onError)

        loadCatalogEbooks = (page, perpage, forceReload) ->
            ebooks_catalog_in_cache = ebooksCache.get('catalog')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.$broadcast('scroll.refreshComplete')
                ebooksCache.put 'catalog', response.list
                $scope.catalogs = response.list
            onError = () ->
                modal.hideLoading()

            if ebooks_catalog_in_cache and not forceReload
                $scope.catalogs = ebooks_catalog_in_cache
            else
                modal.showLoading('', 'message.data_loading')
                api.getCatalogEbooks(page, perpage, onSuccess, onError)

        loadFavoriteEbooks = (page, perpage, forceReload) ->
            ebooks_favorite_in_cache = ebooksCache.get('favorite')

            updateFavoritesMap = (favorites) ->
                $rootScope.ebook_favorites = _.map(favorites, (item) ->
                    return {
                        yearmonth: item.yearmonth
                        catalog: item.catalog
                    }
                )

            onSuccess = (response) ->
                $timeout ->
                    $scope.loading = false
                , 500
                modal.hideLoading()
                $scope.favorites = response.list
                ebooksCache.put 'favorite', response.list

                updateFavoritesMap $scope.favorites

            onError = () ->
                modal.hideLoading()

            if ebooks_favorite_in_cache and not forceReload
                $scope.favorites = ebooks_favorite_in_cache
                updateFavoritesMap ebooks_favorite_in_cache
                $scope.loading = false
            else
                modal.showLoading '', 'message.data_loading'
                api.getMyFavoriteEbooks(page, perpage, onSuccess, onError)

        loadEbookIntro()
        loadCurrentEbooks()
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