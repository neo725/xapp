module.exports = [
    '$rootScope', '$scope', '$log', 'navigation', 'api', 'modal',
    ($rootScope, $scope, $log, navigation, api, modal) ->
        $scope.goBack = ->
            navigation.slide('home.dashboard', {}, 'down')

        $scope.stopPropagation = ($event) ->
            $event.stopPropagation()
            #$log.info 'stopPropagation'

        $scope.goCatalogsSearch = (catalog) ->
            $log.info catalog
            $rootScope.container.catalog = {
                'catalog_name': catalog.Cata_Name
                'catalog_id': catalog.Cata_Id
            }

            navigation.slide 'home.course.search', {}, 'left'

        loadCatalogs = (shop_id) ->
            onSuccess = (response) ->
                modal.hideLoading()
                $scope.catalogs = response.list

            onError = (err) ->
                modal.hideLoading()
                $log.error(err)

            api.getAllCatalogs(shop_id, onSuccess, onError)

        modal.showLoading('', 'message.data_loading')
        loadCatalogs('MS')
]