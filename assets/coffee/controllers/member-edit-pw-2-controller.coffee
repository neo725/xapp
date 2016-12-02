module.exports = [
    '$rootScope', '$scope', '$translate', 'modal', 'navigation', 'plugins', 'api',
    ($rootScope, $scope, $translate, modal, navigation, plugins, api) ->
        $scope.user = {}

        $scope.goBack = ($event) ->
            $event.preventDefault()
            navigation.slide('home.member.edit', {}, 'down')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_password_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_password_edit'],
                        translator['popup.ok']
                    )
                return

            modal.showLoading('', 'message.data_saving')

            onSuccess = (response) ->
                modal.hideLoading()
                delete $rootScope['old_password']
                form.$setPristine()
                form.$setUntouched()
                $scope.goBack({ 'preventDefault': (->) })
                $translate('message.password_saved').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log error
                console.log status_code

            api.updatePassword($rootScope.old_password, $scope.user.new_password, onSuccess, onError)

        $scope.$on('$ionicView.enter', ->
            $scope.user = {}
        )
]