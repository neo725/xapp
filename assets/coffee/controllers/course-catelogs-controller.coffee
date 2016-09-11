module.exports = [
    '$scope', '$log', 'navigation', 'api', ($scope, $log, navigation, api) ->
        $scope.goBack = ->
            navigation.slide('home.dashboard', {}, 'down')

        loadCatelogs = (shop_id) ->
            onSuccess = (response) ->
                $scope.catelogs = response.list

            api.getAllCatelogs(shop_id, onSuccess, (->))

        loadCatelogs('MS')
]