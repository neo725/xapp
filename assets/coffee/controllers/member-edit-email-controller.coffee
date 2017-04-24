module.exports = [
    '$rootScope', '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api',
    ($rootScope, $scope, $translate, navigation, plugins, modal, api) ->
        $scope.user = {}

        $scope.goBack = () ->
            navigation.slide('home.member.edit', {}, 'right')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_email_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_email_edit'],
                        translator['popup.ok']
                    )
                return

            updateMember()

        updateMember = () ->

            data = {
                'mail': $scope.user.confirm_email
            }

            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.member.from = 'edit-email'
                $rootScope.member.new_memb_email = data.mail

                navigation.slide 'main.emailconfirm', {}, 'left'
            onError = () ->
                modal.hideLoading()

            modal.showLoading '', 'message.data_saving'
            api.updateMemberData(data, onSuccess, onError)
]