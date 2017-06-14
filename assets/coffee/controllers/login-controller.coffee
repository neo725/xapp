module.exports = ['$rootScope', '$scope', '$timeout', '$ionicModal', '$translate', '$cordovaOauth', '$state', '$log',
    '$cordovaAppVersion', '$q',
    'plugins', 'modal', 'api', 'navigation', 'user',
    ($rootScope, $scope, $timeout, $ionicModal, $translate, $cordovaOauth, $state, $log,
        $cordovaAppVersion, $q,
        plugins, modal, api, navigation, user) ->

            deferred = $q.defer()

            # dev mode
#            $scope.user = {
#                account: 'sceapp',
#                password: '1234'
#            }
            $scope.user = {}
            $scope.logging = false

    #        clearField = (field) ->
    #            $scope.user[field] = ''
    #            $timeout(->
    #                $("#input-#{field}").focus()
    #            )

            $scope.goForgotPassword = ->
                navigation.slide 'main.forgotpassword', {}, 'left'

            $scope.goRegister = ->
                navigation.slide 'main.register', {}, 'left'

            $scope.goServiceRule = ->
                navigation.slide 'main.service-rule', {}, 'left'

            $scope.goPrivacyRule = ->
                navigation.slide 'main.privacy-rule', {}, 'left'

            $scope.login = ->
                onSuccess = (response) ->
                    modal.hideLoading()
                    user.setToken(response.token_string)
                    user.setIsGuest(false)

                    onSuccess = () ->
                        func = () ->
                            modal.hideLoading()
                            resetLoginButton()
                            $rootScope.callFCMGetToken()
                            navigation.slide 'home.dashboard', {}, 'left'

                        guest_token = user.getGuestToken()

                        if not guest_token
                            return func()

                        mergeToken(guest_token, func)

                    $rootScope.getMemberData(onSuccess, (->))

                onError = () ->
                    modal.hideLoading()
                    window.localStorage.removeItem('token')
                    resetLoginButton()

                $translate('message.logging').then (text) ->
                    $('#login-button').text(text)

                $scope.logging = true
                modal.showLoading '', 'message.logging'

                data =
                    id: $scope.user.account
                    pw: $scope.user.password
                    device: ''

                api.login(data, onSuccess, onError)

            $scope.pass_login = ->
                onSuccess = (response) ->
                    modal.hideLoading()

                    user.setToken(response.token_string)
                    user.setIsGuest(true)
                    resetLoginButton()

                    delete $rootScope['cart']
                    delete $rootScope['wish']

                    navigation.slide 'home.dashboard', {}, 'left'
                    $rootScope.callFCMGetToken()

                onError = () ->
                    modal.hideLoading()
                    resetLoginButton()

                    $translate(['errors.login_failed', 'popup.ok']).then (translation) ->
                        if navigator.notification
                            navigator.notification.alert(
                                translation['errors.login_failed'],
                                (->),
                                '',
                                translation['pop.ok']
                            )

                guest_token = user.getGuestToken()
                if guest_token
                    response =
                        token_string: guest_token
                    user.clearGuestToken()
                    return onSuccess(response)

                $translate('message.logging').then (text) ->
                    $('#pass-button').text(text)

                $scope.logging = true
                modal.showLoading '', 'message.data_loading'

                data =
                    id: 'guest'
                    pw: ''
                    device: ''

                api.login(data, onSuccess, onError)

            $scope.facebook_login = () ->
                appId = '138411713543'
                redirectUrl = 'http://localhost/callback'
                appScope = [
                    'email'
                    'public_profile'
                ]
                $cordovaOauth.facebook(appId, appScope, { redirect_uri: redirectUrl })
                    .then((result) ->
                        token = result.access_token
                        loginBySocial 'facebook', token
                    )

            $scope.google_login = () ->
#                appId = '417861383399-0jqjvm4emqojkv8mtinoaaj0oqm7nd7g.apps.googleusercontent.com'
#                redirectUrl = 'http://localhost/callback'
#                appScope = [
#                    'https://www.googleapis.com/auth/userinfo.email'
#                    'https://www.googleapis.com/auth/userinfo.profile'
#                ]
#                $cordovaOauth.google(appId, appScope, { redirect_uri: redirectUrl })
#                    .then((result) ->
#                        token = result.access_token
#                        loginBySocial 'google', token
#                    )
#                appScope = [
#                    'https://www.googleapis.com/auth/userinfo.email'
#                    'https://www.googleapis.com/auth/userinfo.profile'
#                ]

                detectWhenDeviceReady = () ->
                    return deferred.promise
                success = () ->
                    if window.plugins and window.plugins.googleplus
                        window.plugins.googleplus.getSigningCertificateFingerprint((data) ->
                            $log.info data
                        )
                        window.plugins.googleplus.login(
                            {},
                            (obj) ->
                                token = obj.accessToken
                                loginBySocial 'google', token
                            ,
                            (msg) ->
                                $log.info 'googleplus login error : ' + msg
                        )
                detectWhenDeviceReady().then(success, (->))
#                $translate(['title.notification', 'errors.coming_soon', 'popup.ok']).then (translator) ->
#                    plugins.notification.alert(
#                        translator['errors.coming_soon'],
#                        (->),
#                        translator['title.notification'],
#                        translator['popup.ok']
#                    )

            mergeToken = (guest_token, func) ->
                onSuccess = ->
                    user.clearGuestToken()
                    func()
                onError = (->)

                api.mergeToken guest_token, onSuccess, onError

            resetLoginButton = ->
                $translate('input.login').then (text) ->
                    $('#login-button').text(text)
                $scope.logging = false

            loginBySocial = (provider, token) ->
                onSuccess = (response) ->
                    user.setToken(response.token_string, provider)
                    user.setIsGuest(false)

                    onSuccess = () ->
                        modal.hideLoading()

                        resetLoginButton()

                        $rootScope.callFCMGetToken()

                        navigation.slide 'home.dashboard', {}, 'left'

                    $rootScope.getMemberData(onSuccess, (->))
                onError = () ->
                    modal.hideLoading()
                    resetLoginButton()

                modal.showLoading '', 'message.logging'
                api.postSocialLogin provider, token, onSuccess, onError

            checkDefaultState = ->
                $log.info 'login-controller -> checkDefaultState...'

                token = window.localStorage.getItem('token')

                if token == null
                    navigation.slide 'login', {}, 'left'
                else
                    onSuccess = () ->
                        $rootScope.callFCMGetToken()

                        navigation.slide 'home.dashboard', {}, 'left'

                    $rootScope.getMemberData(onSuccess, (->))

            resetLoginButton()
            checkDefaultState()

            # version number record in config.xml that under project root
            document.addEventListener('deviceready', () ->
                deferred.resolve()
                $cordovaAppVersion.getVersionNumber().then (version)->
                    $scope.app_version = version
            , false)
]
