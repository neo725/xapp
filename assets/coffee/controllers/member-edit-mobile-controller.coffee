module.exports = [
    '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api',
    ($scope, $translate, navigation, plugins, modal, api) ->
        $scope.user = {}

        $scope.goBack = ($event) ->
            $event.preventDefault()
            navigation.slide('home.member.edit', {}, 'down')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_mobile_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_mobile_edit'],
                        translator['popup.ok']
                    )
                return

            modal.showLoading '', 'message.data_saving'

            data = {
                'tel': $scope.user.memb_mobile
            }

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.goBack({ 'preventDefault': (->) })
                $translate('message.data_saved').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = () ->
                modal.hideLoading()

            api.updateMemberData(data, onSuccess, onError)

        return
]