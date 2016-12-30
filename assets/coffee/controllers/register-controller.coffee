module.exports = [
    '$rootScope', '$scope', '$state', '$translate', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $state, $translate, navigation, modal, api, plugins) ->
        $scope.user = {
            name: 'Neo Chang'
            account: 'neochang'
            email: 'neo725@gmail.com'
            email_confirm: 'neo725@gmail.com'
            password: '1234'
            password_confirm: '1234'
            mobile: '0986-716-086'
        }

        $scope.goBack = () ->
            navigation.slide 'login', {}, 'right'

        $scope.submitForm = (form) ->
            if not form.$valid
                #modal.showMessage 'errors.form_validate_error'
                $translate(['title.register_member', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.register_member'],
                        translator['popup.ok']
                    )
                return

            # register
            onSuccess = (response) ->
                modal.hideLoading()

                # login
                onSuccess = (response) ->
                    modal.hideLoading()
                    window.localStorage.setItem("token", response.token_string)
                    window.localStorage.setItem('is_guest', false)

                    onSuccess = ->
                        $rootScope.member.from = 'register'
                        navigation.slide 'main.phoneconfirm', {}, 'left'
                    onError = (->)

                    $rootScope.getMemberData(onSuccess, onError)

                onError = () ->
                    modal.hideLoading()

                data =
                    id: $scope.user.email
                    pw: $scope.user.password
                    device: ''

                api.login(data, onSuccess, onError)

            onError = () ->
                modal.hideLoading()

            $scope.user.mobile = $scope.user.mobile.replace(new RegExp('-', 'g'), '')
            data = {
                email: $scope.user.email
                name: $scope.user.name
                tel: $scope.user.mobile
                password: $scope.user.password
            }

            modal.showLoading '', 'message.data_saving'
            api.registerMember(data, onSuccess, onError)
]