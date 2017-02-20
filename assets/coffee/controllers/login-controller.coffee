module.exports = ['$rootScope', '$scope', '$timeout', '$ionicModal', '$translate', '$cordovaOauth', '$state', '$log',
    '$cordovaAppVersion',
    'modal', 'api', 'navigation',
    ($rootScope, $scope, $timeout, $ionicModal, $translate, $cordovaOauth, $state, $log,
        $cordovaAppVersion,
        modal, api, navigation) ->
            # dev mode
            $scope.user = {
                account: 'sceapp',
                password: '1234'
            }
            $scope.logging = false

            if $rootScope.modalFunction
                $rootScope.modalFunction.hide()

    #        clearField = (field) ->
    #            $scope.user[field] = ''
    #            $timeout(->
    #                $("#input-#{field}").focus()
    #            )

            $scope.goForgotPassword = ->
                navigation.slide 'main.forgotpassword', {}, 'left'

            $scope.goRegister = ->
                navigation.slide 'main.register', {}, 'left'

            resetLoginButton = ->
                $translate('input.login').then (text) ->
                    $('#login-button').text(text)
                $scope.logging = false

            $scope.login = ->
                onSuccess = (response) ->
                    modal.hideLoading()
                    window.localStorage.setItem("token", response.token_string)
                    window.localStorage.setItem('is_guest', false)

                    resetLoginButton()

                    onSuccess = () ->
                        modal.hideLoading()

                        #$rootScope.loadCart()
                        #$rootScope.loadWish()
                        $rootScope.callFCMGetToken()

                        navigation.slide 'home.dashboard', {}, 'left'

                    $rootScope.getMemberData(onSuccess, (->))

                onError = () ->
                    modal.hideLoading()
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

                    window.localStorage.setItem("token", response.token_string)
                    window.localStorage.setItem('is_guest', true)
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
                $cordovaOauth.facebook(appId, ['email'], { redirect_uri: redirectUrl })
                    .then((result) ->
                        token = result.access_token
                        loginBySocial 'facebook', token
                    )

            $scope.google_login = () ->
                appId = '417861383399-0jqjvm4emqojkv8mtinoaaj0oqm7nd7g.apps.googleusercontent.com'
                redirectUrl = 'http://localhost/callback'
                $cordovaOauth.google(appId, ['email'], { redirect_uri: redirectUrl })
                    .then((result) ->
                        token = result.access_token
                        loginBySocial 'google', token
                    )

            loginBySocial = (provider, token) ->
                onSuccess = (response) ->
                    modal.hideLoading()
                    window.localStorage.setItem("token", response.token_string)
                    window.localStorage.setItem('is_guest', false)

                    resetLoginButton()

                    onSuccess = () ->
                        #$rootScope.loadCart()
                        #$rootScope.loadWish()
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

                if token == null or token == "null"
                    navigation.slide 'login', {}, 'left'
                else
                    onSuccess = () ->
                        #$rootScope.loadCart()
                        #$rootScope.loadWish()
                        $rootScope.callFCMGetToken()

                        navigation.slide 'home.dashboard', {}, 'left'

                    $rootScope.getMemberData(onSuccess, (->))

            resetLoginButton()
            checkDefaultState()

            # version number record in config.xml that under project root
            document.addEventListener('deviceready', () ->
                $cordovaAppVersion.getVersionNumber().then (version)->
                    $scope.app_version = version
            , false)
]
