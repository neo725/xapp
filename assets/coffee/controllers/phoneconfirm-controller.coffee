module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicHistory', 'navigation', 'modal', 'api', 'plugins', 'util',
    ($rootScope, $scope, $translate, $ionicHistory, navigation, modal, api, plugins, util) ->
        $scope.goBack = ($event) ->
            $event.preventDefault()
            backView = $ionicHistory.backView()

            console.log $rootScope.member.from
            if backView
                if backView.stateName == 'home.member.edit-mobile'
                    navigation.slide 'home.member.edit', {}, 'down'
                else
                    navigation.slide 'login', {}, 'down'
            else
                navigation.slide('home.dashboard', {}, 'down')

        $scope.submitForm = (form) ->
            if not form.$valid
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
                #console.log response

                modal.showMessage 'message.phone_valid_pass'

                if $rootScope.token_temp
                    window.localStorage.setItem("token", $rootScope.token_temp)
                if $rootScope.member
                    if $rootScope.member.from == 'register'
                        navigation.slide 'login', {}, 'down'
                        return
                    if $rootScope.member.from == 'edit-mobile'
                        navigation.slide 'home.member.edit', {}, 'down'
                        return

                navigation.slide 'login', {}, 'down'

            onError = () ->
                modal.hideLoading()

            action = ''
            if $rootScope.member.from == 'register'
                action = 'register'
            else if $rootScope.member.from == 'edit-mobile'
                action = 'updatetel'

            data = {
                'validcode': util.pad(form.verify_code.$modelValue, 4)
                'membid': $rootScope.member.memb_id
                'action': action
            }
            api.postPhoneValid(data, onSuccess, onError)


        $scope.maskNumber = (number) ->
            return "#{number.substring(0, 4)}***#{number.substring(number.length - 3, number.length)}"

        sendVerifyCode = (member_id, number) ->
            onSuccess = (response) ->
                modal.hideLoading()
                console.log response

            onError = () ->
                modal.hideLoading()

            api.sendValidPhone(encodeURIComponent(member_id), onSuccess, onError)

        if $rootScope.member
            #console.log $rootScope.member
            if $rootScope.member.from == 'edit-mobile'
                $scope.mobile = $rootScope.member.new_memb_mobile
                return
            $scope.mobile = $rootScope.member.memb_mobile
            return sendVerifyCode($rootScope.member.memb_id, $scope.mobile)
        else
            navigation.slide 'login', {}, 'down'
]