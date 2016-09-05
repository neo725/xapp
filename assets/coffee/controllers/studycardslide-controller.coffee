module.exports = [
    '$rootScope', '$scope', '$ionicSlideBoxDelegate', '$log', 'api', 'modal',
    ($rootScope, $scope, $ionicSlideBoxDelegate, $log, api, modal) ->

        onSuccess = (response) ->
            #modal.showMessage 'message.success'
            list = response.list
            $rootScope.studyCardVisible = list.length > 0
            #$rootScope.studyCardVisible = true
            $ionicSlideBoxDelegate.update()

        onError = (response) ->
            $rootScope.studyCardVisible = false
            #modal.showMessage 'message.error'

        api.getStudyCards(onSuccess, onError)
]