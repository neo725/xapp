module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$translate', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $ionicModal, $translate, navigation, modal, api, plugins) ->
        $scope.user = {
            para: ''
        }

        $scope.goBack = ($event) ->
            $event.preventDefault()
            navigation.slide 'login', {}, 'right'

        $scope.confirmClick = () ->
            $scope.modalForgotSended.hide()
            #navigation.slide 'login', {}, 'right'
            navigation.slide 'main.resetpassword', {}, 'left'

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

            onError = (error, status_code) ->
                modal.hideLoading()
                if status_code == 405 and error.popout.indexOf('之內無法傳送簡訊') > -1
                    $scope.modalForgotSended.show()

            modal.showLoading '', 'message.data_loading'
            api.forgotPassword($scope.user.para, onSuccess, onError)

        $ionicModal.fromTemplateUrl('templates/modal-forgot-sended.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalForgotSended = modal
        )
]