module.exports = [
    '$rootScope', '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api', 'util',
    ($rootScope, $scope, $translate, navigation, plugins, modal, api, util) ->
        $scope.user = {}

        $scope.goBack = ($event) ->
            $event.preventDefault()
            navigation.slide('home.member.edit', {}, 'right')

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
                'tel': util.pad($scope.user.memb_mobile, 10)
            }

            redirectToPhoneConfirm = (seconds) ->
                $rootScope.member.from = 'edit-mobile'
                $rootScope.member.new_memb_mobile = data.tel
                $rootScope.member.verify_resend_expire = moment().seconds(seconds)

                navigation.slide 'main.phoneconfirm', {}, 'left'

            onSuccess = (response) ->
                modal.hideLoading()
                seconds = parseInt(response.result)
                redirectToPhoneConfirm seconds

            onError = (error, status_code) ->
                modal.hideLoading()
                if status_code == 405
                    seconds = parseInt(error.result)
                    redirectToPhoneConfirm seconds

            api.updateMemberData(data, onSuccess, onError)

        return
]