module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$log', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $log, navigation, api) ->
        $log.info 'HomeController in'

        checkLoginState = () ->
            $log.info 'home-controller -> checkLoginState'

            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.slide 'login', {}, 'left'

        $rootScope.goCart = ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'

            if is_guest
                return $rootScope.logout()
            else
                navigation.slide 'home.member.cart.step1', {}, 'left'

        $rootScope.logout = ->
            onSuccess = ->
                console.log $rootScope.modalFunction

                window.localStorage.removeItem("token")
                window.localStorage.removeItem("is_guest")
                window.localStorage.removeItem("avatar")

                delete $rootScope['cart']
                delete $rootScope['wish']
                delete $rootScope['member']

                navigation.slide('login', {}, 'right')
            onError = (->)

            token = window.localStorage.getItem('token')
            api.logout(token, onSuccess, onError)

        checkLoginState()

        $scope.$on('$ionicView.enter', (evt, data) ->
            console.log 'home-controller -> $ionicView.enter'
        )
]
