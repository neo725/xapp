module.exports = [
    '$rootScope', '$ionicHistory', '$log', 'navigation', ($rootScope, $ionicHistory, $log, navigation) ->
        $log.info 'HomeController in'

        checkLoginState = () ->
            $log.info 'home-controller -> checkLoginState'

            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.flip 'login', {}, 'left'

        $rootScope.goCart = ->
            navigation.slide 'home.member.cart.step1', {}, 'left'

        checkLoginState()
]
