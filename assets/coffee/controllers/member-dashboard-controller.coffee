module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$timeout', 'modal', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $timeout, modal, navigation, api) ->

        $scope.goBack = ->
            navigation.slide 'home.dashboard', {}, 'right'

        $scope.goWishList = ->
            navigation.slide 'home.member.wish', {}, 'left'

        $scope.goOrderList = ->
            navigation.slide 'home.member.order', {}, 'left'

        $scope.goFinishList = ->
            navigation.slide 'home.member.finish', {}, 'left'

        $scope.goMessageList = ->
            navigation.slide 'home.member.message', {}, 'left'

        $scope.goEdit = ->
            $scope.modalFunction.hide()
            $timeout(->
                navigation.slide 'home.member.edit', {}, 'up'
            )

        $scope.goSuggest = ->
            $scope.modalFunction.hide()
            $timeout(->
                navigation.slide 'home.member.suggestion', {}, 'up'
            )

        $scope.logout = ->
            $scope.modalFunction.hide()
            $rootScope.logout()

        # version number record in config.xml that under project root
        document.addEventListener('deviceready', () ->
            $cordovaAppVersion.getVersionNumber().then (version)->
                $scope.app_version = version
        , false)

        $ionicModal.fromTemplateUrl('templates/modal-function.html',
            scope: $scope
            animation: 'slide-in-up'
        ).then((modal) ->
            $scope.modalFunction = modal
        )
]