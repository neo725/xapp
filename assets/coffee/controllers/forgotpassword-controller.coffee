module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$state', '$translate', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $ionicModal, $state, $translate, navigation, modal, api, plugins) ->
        $scope.user = {
            name: ''
            email: ''
        }

        $scope.goBack = () ->
            navigation.slide 'login', {}, 'down'

        $scope.confirmClick = () ->
            $scope.modalForgotSended.hide()
            navigation.slide 'login', {}, 'down'

        $scope.submitForm = (form) ->
            if not form.$valid
                #modal.showMessage 'errors.form_validate_error'
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
                $scope.modalForgotSended.show()

            onError = () ->
                modal.hideLoading()

            data = {
                email: $scope.user.email
                name: $scope.user.name
            }

            modal.showLoading '', 'message.data_loading'
            api.forgotPassword(data, onSuccess, onError)

        $ionicModal.fromTemplateUrl('templates/modal-forgot-sended.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalForgotSended = modal
        )
]