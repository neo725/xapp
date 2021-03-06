module.exports = [
    '$rootScope', '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api',
    ($rootScope, $scope, $translate, navigation, plugins, modal, api) ->
        $scope.user = {}

        $scope.user.memb_name = $rootScope.member.memb_name

        $scope.goBack = () ->
            navigation.slide('home.member.edit', {}, 'right')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_name_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_name_edit'],
                        translator['popup.ok']
                    )
                return

            updateMember()

        updateMember = () ->

            data = {
                'name': $scope.user.memb_name
            }

            onSuccess = (response) ->
                modal.hideLoading()
                $translate('message.data_saved').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
                    $rootScope.member = null
                    $scope.goBack()
            onError = () ->
                modal.hideLoading()

            modal.showLoading '', 'message.data_saving'
            api.updateMemberData(data, onSuccess, onError)
]