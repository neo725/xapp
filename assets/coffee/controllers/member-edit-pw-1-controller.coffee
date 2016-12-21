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

            modal.showLoading('', 'message.verifying')

            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.old_password = $scope.user.password
                form.$setPristine()
                form.$setUntouched()
                navigation.slide 'home.member.edit-pw-2', {}, 'left'
            onError = () ->
                modal.hideLoading()

            api.verifyPassword($scope.user.password, onSuccess, onError)

        $scope.$on('$ionicView.enter', ->
            $scope.user = {}
        )
]