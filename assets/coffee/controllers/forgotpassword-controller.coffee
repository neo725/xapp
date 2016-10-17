module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$state', 'navigation', 'modal', 'api'
    ($rootScope, $scope, $ionicModal, $state, navigation, modal, api) ->
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
                modal.showMessage 'errors.form_validate_error'
                return

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.modalForgotSended.show()

            onError = (error, status_code) ->
                modal.hideLoading()
                console.log 'info'
                console.log status_code
                console.log error
                modal.showMessage 'errors.request_failed'

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