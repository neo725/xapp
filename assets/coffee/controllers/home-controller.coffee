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
#            is_guest = user.getIsGuest()
#
#            if is_guest
#                return $rootScope.logout()
#            else
#                navigation.slide 'home.member.cart.step1', {}, 'left'
            navigation.slide 'home.member.cart.step1', {}, 'left'

        $rootScope.goGuestLogin = ->
            token = user.getToken()

            func = (token) ->
                user.setGuestToken(token)

            $rootScope.logout(() ->
                func(token)
            )

        $rootScope.goGuestRegister = ->
            token = user.getToken()

            func = (token) ->
                user.setGuestToken(token)

            $rootScope.logout(() ->
                    func(token)
                , 'main.register'
            )

        $rootScope.logout = (func, next_state = 'login') ->
            logout = ->
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

                    if func
                        func()

                    navigation.slide(next_state, {}, 'right')
                    modal.hideLoading()

                onError = ->
                    modal.hideLoading()

                if func
                    return onSuccess()

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
