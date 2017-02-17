module.exports = ['$rootScope',
    ($rootScope) ->
        isGuest = () ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'
            return is_guest

        isRealDevice = () ->
            ua = ionic.Platform.ua
            isRealDevice = ua.indexOf('SM-G900P') == -1

            return isRealDevice

        isLogin = () ->
            token = window.localStorage.getItem('token')

            return $rootScope.member != undefined

        return {
            isGuest: isGuest
            isRealDevice: isRealDevice
            isLogin: isLogin
        }
]