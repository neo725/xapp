module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$log', 'navigation', 'api', 'CacheFactory', 'user',
    ($rootScope, $scope, $ionicHistory, $log, navigation, api, CacheFactory, user) ->
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

                    delete $rootScope['cart']
                    delete $rootScope['wish']
                    delete $rootScope['member']

                    navigation.slide('login', {}, 'right')

                onError = (->)

                token = window.localStorage.getItem('token')
                api.logout(token, onSuccess, onError)

            deleteDeviceToken = (func) ->
                onSuccess = () ->
                    window.localStorage.removeItem("device_token")

                    func()
                onError = (->)

                token = window.localStorage.getItem('device_token')
                if token == null
                    func()
                else
                    api.deleteDeviceToken token, onSuccess, onError

            deleteDeviceToken(logout)

        checkLoginState()

        $scope.$on('$ionicView.enter', (evt, data) ->
            $log.info 'home-controller -> $ionicView.enter'
        )
]
