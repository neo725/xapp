module.exports = [
    '$rootScope', '$scope', '$log', 'navigation', 'api', 'modal', 'CacheFactory',
    ($rootScope, $scope, $log, navigation, api, modal, CacheFactory) ->
        $scope.mode = 'List' # 'Setting', 'List'
        choiceCatalogs = []

        if not CacheFactory.get('catalogsCache')
            opts =
                maxAge: 7 * 24 * 60 * 60 * 1000
                deleteOnExpire: 'aggressive'
            CacheFactory.createCache('catalogsCache', opts)
        catalogsCache = CacheFactory.get('catalogsCache')

        $scope.goBack = ->
            navigation.slide('home.dashboard', {}, 'right')

        $scope.goSetting = ->
            $scope.visibleCatalogs = $scope.catalogs
            $scope.mode = 'Setting'

        $scope.saveSetting = ->
            onSuccess = () ->
                $scope.mode = 'List'
                catalogsCache.removeAll()
                loadAllCatalogs('MS')
            onError = (->)

            api.saveCatalogsSetting('MS', choiceCatalogs, onSuccess, onError)

        $scope.toggleCatalogItem = (catalog_id, $event) ->
            $event.stopPropagation()
            index = _.indexOf(choiceCatalogs, catalog_id)

            if index == -1
                choiceCatalogs.push catalog_id
            else
                choiceCatalogs.splice(index, 1)

            index = _.findIndex($scope.user_catalogs, { 'Cata_Id': catalog_id })

            if index > -1
                $scope.user_catalogs.splice(index, 1)

        $scope.checkCatalogIsChecked = (catalog_id) ->
            catalogs = $scope.user_catalogs || []
            index = _.findIndex(catalogs, { 'Cata_Id': catalog_id })

            if index > -1 and _.indexOf(choiceCatalogs, catalog_id) == -1
                choiceCatalogs.push catalog_id

            return index > -1

        $scope.goCatalogsSearch = (catalog) ->
            $rootScope.catalog = {
                'catalog_name': catalog.Cata_Name
                'catalog_id': catalog.Cata_Id
            }

            navigation.slide 'home.course.search', {}, 'left'

        $scope.doRefresh = () ->
            loadAllCatalogs 'MS', true

        loadUserCatalogs = (shop_id, forceReload) ->
            catalogs_user_in_cache = catalogsCache.get('user')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.user_catalogs = response.list
                $scope.visibleCatalogs = $scope.user_catalogs
                catalogsCache.put 'user', response.list

            onError = (error, status_code) ->
                modal.hideLoading()
                if status_code == 404
                    # no saved data
                    $scope.mode = 'Setting'
                    $scope.user_catalogs = []
                    $scope.visibleCatalogs = $scope.catalogs

            if catalogs_user_in_cache and not forceReload
                $scope.user_catalogs = catalogs_user_in_cache
                $scope.visibleCatalogs = $scope.user_catalogs
            else
                modal.showLoading('', 'message.data_loading')
                api.getUserCatalogs(shop_id, onSuccess, onError)

        loadAllCatalogs = (shop_id, forceReload) ->
            catalogs_all_in_cache = catalogsCache.get('all')

            onSuccess = (response) ->
                $scope.catalogs = response.list
                catalogsCache.put 'all', $scope.catalogs

                modal.hideLoading()
                loadUserCatalogs(shop_id, forceReload)

            onError = () ->
                modal.hideLoading()

            if catalogs_all_in_cache and not forceReload
                $scope.catalogs = catalogs_all_in_cache
                loadUserCatalogs(shop_id)
            else
                modal.showLoading('', 'message.data_loading')
                api.getAllCatalogs(shop_id, onSuccess, onError)


        loadAllCatalogs('MS')
]