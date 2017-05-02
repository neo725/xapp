module.exports = [
    '$rootScope', '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api', 'util',
    ($rootScope, $scope, $translate, navigation, plugins, modal, api, util) ->
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

            redirectToEmailConfirm = (seconds) ->
                $rootScope.member.from = 'edit-email'
                $rootScope.member.new_memb_email = data.mail
                $rootScope.member.verify_resend_expire = util.getMomentNowAddSeconds(seconds)

                navigation.slide 'main.emailconfirm', {}, 'left'

            onSuccess = (response) ->
                modal.hideLoading()

                seconds = parseInt(response.result)
                redirectToEmailConfirm seconds

            onError = (error, status_code) ->
                modal.hideLoading()
                if status_code == 405
                    seconds = parseInt(error.result)
                    redirectToEmailConfirm seconds

            modal.showLoading '', 'message.data_saving'
            api.updateMemberData(data, onSuccess, onError)
]