module.exports = ['$rootScope', '$scope', '$timeout', '$ionicModal', '$ionicPopup', '$translate', '$state', '$log', 'modal', 'api', 'navigation'
    ($rootScope, $scope, $timeout, $ionicModal, $ionicPopup, $translate, $state, $log, modal, api, navigation) ->
        # dev mode
        $scope.user = {
            account: 'thchang@sce.pccu.edu.tw',
            password: '1234'
        }
        $scope.logging = false

        if $rootScope.modalFunction
            $rootScope.modalFunction.hide()

        clearField = (field) ->
            $scope.user[field] = ''
            $timeout(->
                $("#input-#{field}").focus()
            )

        $scope.forgotpassword = ->
            navigation.slide 'main.forgotpassword', {}, 'up'

        resetLoginButton = ->
            $translate('input.login').then (text) ->
                $('#login-button').text(text)
            $scope.logging = false

        $scope.login = ->
            onSuccess = (response) ->
                window.localStorage.setItem("token", response.token_string)
                window.localStorage.setItem('is_guest', false)
                resetLoginButton()
                navigation.flip 'home.dashboard', {}, 'left'
                $rootScope.callFCMGetToken()

            onError = (response) ->
                modal.hideLoading()
                resetLoginButton()
                if response
                    $translate(['errors.login_failed', 'popup.ok']).then (translation) ->
                        #ionicPopup version
#                        alertPopup = $ionicPopup.alert({
#                            template: translation['errors.login_failed'],
#                            okText: translation['popup.ok']
#                        })
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
            modal.showLoading '', 'logging'

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
                navigation.flip 'home.dashboard', {}, 'left'
                $rootScope.callFCMGetToken()

            onError = (response) ->
                modal.hideLoading()
                resetLoginButton()
                if response
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
            modal.showLoading '', 'logging'

            data =
                id: 'guest'
                pw: ''
                device: ''

            api.login(data, onSuccess, onError)

        resetLoginButton()
]
