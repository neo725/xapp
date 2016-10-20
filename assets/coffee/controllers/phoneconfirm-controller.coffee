module.exports = [
    '$rootScope', '$scope', '$translate', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $translate, navigation, modal, api, plugins) ->
        $scope.goBack = () ->
            navigation.slide 'login', {}, 'down'

        $scope.submitForm = (form) ->
            if not form.$valid
                #modal.showMessage 'errors.form_validate_error'
                $translate(['title.phone_confirm', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.phone_confirm'],
                        translator['popup.ok']
                    )
                return

            onSuccess = (response) ->
                modal.hideLoading()
                console.log response

                modal.showMessage 'message.phone_valid_pass'

                window.localStorage.setItem("token", $rootScope.token_temp)
                navigation.slide 'login', {}, 'down'

            onError = (error, status_code) ->
                modal.hideLoading()
                switch error
                    when 'no match valid' then modal.showMessage('errors.phone_valid_error')

                console.log status_code
                console.log error

            data = {
                'validcode': form.verify_code.$modelValue
                'membid': $rootScope.member.memb_email
            }
            api.postPhoneValid(data, onSuccess, onError)


        $scope.maskNumber = (number) ->
            return "#{number.substring(0, 4)}***#{number.substring(number.length - 3, number.length)}"

        sendVerifyCode = (member_email, number) ->
            onSuccess = (response) ->
                modal.hideLoading()
                console.log response

            onError = (error, status_code) ->
                modal.hideLoading()
                console.log status_code
                console.log error

            api.sendValidPhone(encodeURIComponent(member_email), onSuccess, onError)

        if $rootScope.member
            $scope.mobile = $rootScope.member.memb_mobile
            return sendVerifyCode($rootScope.member.memb_email, $scope.mobile)
        else
            navigation.slide 'login', {}, 'down'
]