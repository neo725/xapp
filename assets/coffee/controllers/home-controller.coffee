module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$cordovaBadge', '$log', 'navigation', 'api', 'CacheFactory', 'user', 'modal',
    ($rootScope, $scope, $ionicHistory, $cordovaBadge, $log, navigation, api, CacheFactory, user, modal) ->
        #$log.info 'HomeController in'

        checkLoginState = () ->
            $log.info 'home-controller -> checkLoginState'

            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.slide 'login', {}, 'left'

        $rootScope.goCart = ->
            is_guest = user.isGuest()

            if is_guest
                return $rootScope.logout()
            else
                navigation.slide 'home.member.cart.step1', {}, 'left'

        $rootScope.logout = ->
            logout = () ->
                onSuccess = ->
                    $rootScope.loadStudycardSlide = true
                    $rootScope.loadSearchSlide = true

                    window.localStorage.clear()
                    window.sessionStorage.clear()

                    if window.cordova
                        $cordovaBadge.clear()

                    delete $rootScope['cart']
                    delete $rootScope['wish']
                    delete $rootScope['member']

                    navigation.slide('login', {}, 'right')
                    modal.hideLoading()

                onError = ->
                    modal.hideLoading()

                modal.showLoading '', 'message.logging'
                token = window.localStorage.getItem('token')
                api.logout(token, onSuccess, onError)

            deleteDeviceToken = (func) ->
                onSuccess = () ->
                    modal.hideLoading()
                    window.localStorage.removeItem("device_token")

                    func()
                onError = ->
                    modal.hideLoading()

                token = window.localStorage.getItem('device_token')
                if token == null
                    func()
                else
                    modal.showLoading '', 'message.logging'
                    api.deleteDeviceToken token, onSuccess, onError

            deleteDeviceToken(logout)

        checkLoginState()

        $scope.$on('$ionicView.enter', (evt, data) ->
            $log.info 'home-controller -> $ionicView.enter'
        )
]
