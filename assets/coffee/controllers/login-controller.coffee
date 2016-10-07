module.exports = ['$rootScope', '$scope', '$timeout', '$ionicModal', '$translate', '$state', '$log', 'modal', 'api', 'navigation'
    ($rootScope, $scope, $timeout, $ionicModal, $translate, $state, $log, modal, api, navigation) ->
        # dev mode
        $scope.user = {
            account: 'thchang@sce.pccu.edu.tw',
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
                window.localStorage.setItem("token", response.token_string)
                window.localStorage.setItem('is_guest', false)
                resetLoginButton()
                $rootScope.loadCart()
                $rootScope.loadWish()

                navigation.flip 'home.dashboard', {}, 'left'
                $rootScope.callFCMGetToken()

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

        checkDefaultState = ->
            $log.info 'login-controller -> checkDefaultState...'

        resetLoginButton()
        checkDefaultState()
]
