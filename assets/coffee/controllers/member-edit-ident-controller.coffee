module.exports = [
    '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api',
    ($scope, $translate, navigation, plugins, modal, api) ->
        $scope.user = {}

        $scope.goBack = () ->
            navigation.slide('home.member.edit', {}, 'right')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_ident_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_ident_edit'],
                        translator['popup.ok']
                    )
                return

            modal.showLoading '', 'message.data_saving'

            data = {
                'ident': $scope.user.ident_confirm
            }

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.goBack({ 'preventDefault': (->) })
                $translate('message.data_saved').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = () ->
                modal.hideLoading()

            api.updateMemberData(data, onSuccess, onError)
]