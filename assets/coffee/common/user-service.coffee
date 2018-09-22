module.exports = ['$rootScope', 'plugins'
    ($rootScope, plugins) ->
        getIsGuest = () ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'
            return is_guest

        setIsGuest = (value = true) ->
            window.localStorage.setItem('is_guest', value)

        clearIsGuest = () ->
            window.localStorage.removeItem('is_guest')

        getToken = () ->
            token = window.localStorage.getItem('token')
            if plugins && plugins.clipboard
                plugins.clipboard.copy(token)
            
            return token

        setToken = (token, social_platform) ->
            window.localStorage.setItem('token', token)
            
            if social_platform
                window.localStorage.setItem('social_platform', social_platform)
            else
                window.localStorage.removeItem('social_platform')

        clearToken = () ->
            window.localStorage.removeItem('token')
            window.localStorage.removeItem('social_platform')

        getSocialPlatform = () ->
            return window.localStorage.getItem('social_platform')

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
            getSocialPlatform: getSocialPlatform
            setGuestToken: setGuestToken
            getGuestToken: getGuestToken
            clearGuestToken: clearGuestToken
        }
]