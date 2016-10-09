module.exports = [
    '$scope', '$ionicHistory', 'modal', 'navigation', 'api', ($scope, $ionicHistory, modal, navigation, api) ->


        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        loadLocation = ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.locations = response.list
            onError = ->
                modal.hideLoading()

            api.getLocations(onSuccess, onError)

        loadLocation()
]