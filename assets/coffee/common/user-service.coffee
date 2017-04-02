module.exports = ['$rootScope',
    ($rootScope) ->
        getIsGuest = () ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'
            return is_guest

        setIsGuest = (value = true) ->
            window.localStorage.setItem('is_guest', value)

        clearIsGuest = () ->
            window.localStorage.removeItem('is_guest')

        getToken = () ->
            return window.localStorage.getItem('token')

        setToken = (token) ->
            window.localStorage.setItem('token', token)

        clearToken = () ->
            window.localStorage.removeItem('token')

        setGuestToken = (token) ->
            if token
                window.localStorage.setItem('guest_token', token)

        getGuestToken = () ->
            return window.localStorage.getItem('guest_token')

        clearGuestToken = () ->
            window.localStorage.removeItem('guest_token')

        isRealDevice = () ->
            ua = ionic.Platform.ua
            isRealDevice = ua.indexOf('SM-G900P') == -1

            return isRealDevice

        isLogin = () ->
            token = window.localStorage.getItem('token')

            return $rootScope.member != undefined

        return {
            getIsGuest: getIsGuest
            isRealDevice: isRealDevice
            isLogin: isLogin
            setIsGuest: setIsGuest
            clearIsGuest: clearIsGuest
            getToken: getToken
            setToken: setToken
            clearToken: clearToken
            setGuestToken: setGuestToken
            getGuestToken: getGuestToken
            clearGuestToken: clearGuestToken
        }
]