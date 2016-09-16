module.exports = [
    '$rootScope', '$ionicHistory', '$log', 'navigation', ($rootScope, $ionicHistory, $log, navigation) ->
        $log.info 'HomeController in'

        checkLoginState = () ->
            $log.info 'home-controller -> checkLoginState'

            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.flip 'login', {}, 'left'

        checkLoginState()
]
