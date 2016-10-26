module.exports = [
    '$scope', '$ionicHistory', 'modal', 'navigation', 'api', ($scope, $ionicHistory, modal, navigation, api) ->


        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.goMap = (address, gps, $event) ->
            $event.stopPropagation()
            console.log address
            console.log gps

        $scope.goPhoneCall = (number, $event) ->
            $event.stopPropagation()
            console.log number

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