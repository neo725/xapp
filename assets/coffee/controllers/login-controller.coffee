module.exports = ['$rootScope', '$scope', '$timeout', '$ionicModal', '$translate', '$cordovaOauth', '$state', 'modal', 'api', 'navigation'
    ($rootScope, $scope, $timeout, $ionicModal, $translate, $cordovaOauth, $state, modal, api, navigation) ->
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
            navigation.slide 'main.forgotpassword', {}, 'up'

        $scope.goRegister = ->
            navigation.slide 'main.register', {}, 'up'

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
                    $rootScope.loadCart()
                    $rootScope.loadWish()
                    $rootScope.callFCMGetToken()

                    navigation.flip 'home.dashboard', {}, 'left'

                $rootScope.getMemberData(onSuccess, (->))

            onError = (response) ->
                modal.hideLoading()
                resetLoginButton()
                if response
                    $translate(['errors.login_failed', 'popup.ok']).then (translation) ->
#                       # TODO: move navigator.notification to plugins.notification
                        if navigator.notification
                            navigator.notification.alert(
                                translation['errors.login_failed'],
                                (->),
                                '',
                                translation['pop.ok']
                            )

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
                window.localStorage.setItem("token", response.token_string)
                window.localStorage.setItem('is_guest', true)
                resetLoginButton()

                delete $rootScope['cart']
                delete $rootScope['wish']

                navigation.flip 'home.dashboard', {}, 'left'
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
            modal.showLoading '', 'message.logging'

            data =
                id: 'guest'
                pw: ''
                device: ''

            api.login(data, onSuccess, onError)

        $scope.facebook_login = () ->
            #console.log 'facebook_login'
            appId = '138411713543'
            redirectUrl = 'http://localhost/callback'
            $cordovaOauth.facebook(appId, ['email', 'public_profile'], { redirect_uri: redirectUrl })
                .then((result) ->
                    token = result.access_token
                    console.log token
                )

        $scope.google_login = () ->
            #console.log 'google_login'
            appId = '417861383399-0jqjvm4emqojkv8mtinoaaj0oqm7nd7g.apps.googleusercontent.com'
            redirectUrl = 'http://localhost/callback'
            $cordovaOauth.google(appId, ['email'], { redirect_uri: redirectUrl })
                .then((result) ->
                    token = result.access_token
                    console.log token
                )

        checkDefaultState = ->
            console.log 'login-controller -> checkDefaultState...'

            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.flip 'login', {}, 'left'
            else
                onSuccess = () ->
                    $rootScope.loadCart()
                    $rootScope.loadWish()
                    $rootScope.callFCMGetToken()

                    navigation.flip 'home.dashboard', {}, 'left'

                $rootScope.getMemberData(onSuccess, (->))

        resetLoginButton()
        checkDefaultState()
]
