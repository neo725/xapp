module.exports = [
    '$rootScope', '$scope', '$translate', '$log', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $translate, $log, navigation, modal, api, plugins) ->
        $scope.receive_data = 'thchang@sce.pccu.edu.tw'
        $scope.user =
            email: ''
            valid_code: ''
            password: ''

        $scope.goBack = () ->
            navigation.slide 'login', {}, 'right'

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.forget_password', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.forget_password'],
                        translator['popup.ok']
                    )
                return

            onSuccess = (response) ->
                modal.hideLoading()
                onCallback = ->
                    navigation.slide 'login', {}, 'right'
                if response and response.popout
                    $translate(['popup.ok']).then (translator) ->
                        plugins.notification.confirm(
                            response.popout,
                            onCallback,
                            '',
                            [translator['popup.ok']]
                        )
            onError = ->
                modal.hideLoading()

            modal.showLoading '', 'message.data_loading'
            data =
                mail: $scope.user.email
                valid: $scope.user.valid_code
                newPW: $scope.user.password
            api.resetPassword(data, onSuccess, onError)
]