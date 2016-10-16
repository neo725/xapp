module.exports = [
    '$rootScope', '$ionicHistory', '$log', 'navigation', 'api', ($rootScope, $ionicHistory, $log, navigation, api) ->
        $log.info 'HomeController in'

        checkLoginState = () ->
            $log.info 'home-controller -> checkLoginState'

            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.flip 'login', {}, 'left'

        $rootScope.goCart = ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'

            if is_guest
                return $rootScope.logout()
            else
                navigation.slide 'home.member.cart.step1', {}, 'left'

        $rootScope.logout = ->
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

        checkLoginState()
]
