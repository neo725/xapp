module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$log', 'modal', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $log, modal, navigation, api) ->

        $scope.goBack = ->
            navigation.slide 'home.dashboard', {}, 'right'

        $scope.goCart = ->
            navigation.slide 'home.member.cart.step1', {}, 'left'

        $scope.goWishList = ->
            navigation.slide 'home.member.wish', {}, 'left'

        $scope.goOrderList = ->
            navigation.slide 'home.member.order', {}, 'left'

        $scope.logout = ->
            onSuccess = ->
                window.localStorage.removeItem("token")
                window.localStorage.removeItem("is_guest")
                delete $rootScope['cart']
                delete $rootScope['wish']

                navigation.flip('login', {}, 'right')
            onError = ->
                modal.showMessage 'errors.request_failed'

            token = window.localStorage.getItem('token')
            api.logout(token, onSuccess, onError)

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