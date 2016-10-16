module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$log', 'modal', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $log, modal, navigation, api) ->

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

        # version number record in config.xml that under project root
        document.addEventListener('deviceready', () ->
            $cordovaAppVersion.getVersionNumber().then (version)->
                $scope.app_version = version
        , false)

        $ionicModal.fromTemplateUrl('templates/modal-function.html',
            scope: $scope
            animation: 'slide-in-up'
        ).then((modal) ->
            $rootScope.modalFunction = modal
        )
]