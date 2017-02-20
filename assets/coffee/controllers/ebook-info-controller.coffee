module.exports = [
    '$rootScope', '$scope', '$stateParams', '$ionicHistory', '$timeout', '$sce', '$translate', '$log',
    'navigation', 'modal', 'plugins', 'api', 'CacheFactory', 'util',
    ($rootScope, $scope, $stateParams, $ionicHistory, $timeout, $sce, $translate, $log,
        navigation, modal, plugins, api, CacheFactory, util) ->
            $scope.loading = false
            $scope.alreadyAddFavorites = false

            if not CacheFactory.get('ebooksCache')
                maxAge = util.getCacheMaxAge 23, 59, 59
                opts =
                    maxAge: maxAge
                    deleteOnExpire: 'aggressive'
                CacheFactory.createCache('ebooksCache', opts)
            ebooksCache = CacheFactory.get('ebooksCache')

            yearmonth = $stateParams.yearmonth
            catalog_id = $stateParams.catalog_id

            alreadyGoBack = false

            $scope.goBack = ->
                alreadyGoBack = true
                backView = $ionicHistory.backView()

                if backView
                    navigation.slide(backView.stateName, backView.stateParams, 'right')
                else
                    navigation.slide('home.dashboard', {}, 'right')

            $scope.addToFavorite = ($event, ebook) ->
                if $scope.alreadyAddFavorites
                    deleteFromFavorites ebook
                    return
                $button = $($event.currentTarget)
                $button.find('i').removeClass('sprite-icon-ebook-add-favorite').addClass('sprite-icon-ebook-del-favorite')

                modal.showLoading '', 'message.processing'

                onSuccess = (response) ->
                    addToFavoriteCache ebook
                    $scope.alreadyAddFavorites = true
                    modal.hideLoading()
                    $translate('message.success_to_add_favorite_ebook').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                onError = () ->
                    modal.hideLoading()

                api.addEbookFavorite(yearmonth, catalog_id, onSuccess, onError)

            deleteFromFavorites = (ebook) ->
                modal.showLoading '', 'message.processing'

                onSuccess = () ->
                    deleteFromFavoriteCache ebook
                    $scope.alreadyAddFavorites = false
                    modal.hideLoading()

                    $translate('message.success_to_delete_favorite_ebook').then (text) ->
                        plugins.toast.show(text, 'long', 'top')

                onError = () ->
                    modal.hideLoading()

                api.deleteFavoriteEbook(ebook.yearmonth, ebook.catalog, onSuccess, onError)

            addToFavoriteCache = (ebook) ->
                ebooks_favorite_in_cache = ebooksCache.get('favorite') || []
                ebooks_favorite_in_cache.push ebook

                ebooksCache.put 'favorite', ebooks_favorite_in_cache

            deleteFromFavoriteCache = (ebook) ->
                ebooks_favorite_in_cache = ebooksCache.get('favorite') || []
                index = _.findIndex(ebooks_favorite_in_cache, { yearmonth: ebook.yearmonth, catalog: ebook.catalog })
                if index > -1
                    ebooks_favorite_in_cache.splice index, 1
                ebooksCache.put 'favorite', ebooks_favorite_in_cache

            loadCatalogEbook = (yearmonth, catalog_id) ->
                cache_key = "ebook-#{yearmonth}-#{catalog_id}"
                ebook_info_in_cache = ebooksCache.get cache_key

                index = _.findIndex($rootScope.ebook_favorites, { yearmonth: yearmonth, catalog: catalog_id })
                $scope.alreadyAddFavorites = (index > -1)

                loadEbookInfo = (ebook) ->
                    $scope.ebook = ebook

                    $iframe = $(document.getElementById('iframe'))
                    $iframe.contents().find('html').html(ebook.html)

                    loopTimes = 0
                    timeoutInterval = 100
                    autoHeight = (maxLoopSecs) ->
                        $timeout ->
                            if alreadyGoBack
                                return
                            loopTimes += 1

                            emptyContent = $iframe.contents().length == 0

                            if emptyContent
                                return

                            if not emptyContent
                                height = $iframe.contents().find('html').height()
                                $iframe.height(height + 'px')

                            if loopTimes < (maxLoopSecs * (1000 / timeoutInterval))
                                autoHeight(maxLoopSecs)
                        , timeoutInterval

                    autoHeight(5)

                onSuccess = (response) ->
                    ebooksCache.put cache_key, response
                    loadEbookInfo response
                    modal.hideLoading()
                onError = () ->
                    modal.hideLoading()

                if ebook_info_in_cache
                    $timeout ->
                        loadEbookInfo ebook_info_in_cache
                    , 500
                else
                    modal.showLoading '', 'message.data_loading'
                    api.getCatalogEbook yearmonth, catalog_id, onSuccess, onError

            $scope.$on('$ionicView.enter', (evt, data) ->
                $scope.loading = true

                loadCatalogEbook yearmonth, catalog_id

                $scope.loading = false

                $('.ebook-info-content').prepend($('.add-favorite'))
            )
]