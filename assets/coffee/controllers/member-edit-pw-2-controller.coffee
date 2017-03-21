module.exports = [
    '$rootScope', '$scope', '$translate', 'modal', 'navigation', 'plugins', 'api',
    ($rootScope, $scope, $translate, modal, navigation, plugins, api) ->
        $scope.user = {}

        $scope.goBack = () ->
            navigation.slide('home.member.edit', {}, 'right')

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
            onError = () ->
                modal.hideLoading()

            api.updatePassword($rootScope.old_password, $scope.user.new_password, onSuccess, onError)

        $scope.$on('$ionicView.enter', ->
            $scope.user = {}
        )
]