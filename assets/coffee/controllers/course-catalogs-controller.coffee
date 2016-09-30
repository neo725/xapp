module.exports = [
    '$rootScope', '$scope', '$log', 'navigation', 'api', 'modal',
    ($rootScope, $scope, $log, navigation, api, modal) ->
        $scope.mode = 'List' # 'Setting', 'List'
        choiceCatalogs = []

        $scope.goBack = ->
            navigation.slide('home.dashboard', {}, 'down')

        $scope.goSetting = ->
            $scope.visibleCatalogs = $scope.catalogs
            $scope.mode = 'Setting'

        $scope.saveSetting = ->
            onSuccess = (response) ->
                loadAllCatalogs('MS')
                $scope.mode = 'List'
            onError = (->)

            api.saveCatalogsSetting('MS', choiceCatalogs, onSuccess, onError)

        $scope.toggleCatalogItem = (catalog_id, $event) ->
            $event.stopPropagation()
            index = _.indexOf(choiceCatalogs, catalog_id)
            if index == -1
                choiceCatalogs.push catalog_id
            else
                choiceCatalogs.splice(index, 1)

        $scope.checkCatalogIsChecked = (catalog_id) ->
            catalogs = $scope.user_catalogs || []
            index = _.findIndex(catalogs, { 'Cata_Id': catalog_id })
            return index > -1

        $scope.goCatalogsSearch = (catalog) ->
            $rootScope.catalog = {
                'catalog_name': catalog.Cata_Name
                'catalog_id': catalog.Cata_Id
            }

            navigation.slide 'home.course.search', {}, 'left'

        loadAllCatalogs = (shop_id) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                $scope.catalogs = response.list
                loadUserCatalogs(shop_id)

            onError = () ->
                modal.hideLoading()

            api.getAllCatalogs(shop_id, onSuccess, onError)

        loadUserCatalogs = (shop_id) ->
            onSuccess = (response) ->
                modal.hideLoading()
                $scope.user_catalogs = response.list
                $scope.visibleCatalogs = $scope.user_catalogs

            onError = (error, status_code) ->
                modal.hideLoading()
                if status_code == 404
                    # no saved data
                    $scope.mode = 'Setting'
                    $scope.user_catalogs = []
                    $scope.visibleCatalogs = $scope.catalogs

            api.getUserCatalogs('MS', onSuccess, onError)

        loadAllCatalogs('MS')
]