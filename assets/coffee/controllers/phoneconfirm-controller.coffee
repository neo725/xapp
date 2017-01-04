module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicHistory', '$timeout', 'navigation', 'modal', 'api', 'plugins', 'util',
    ($rootScope, $scope, $translate, $ionicHistory, $timeout, navigation, modal, api, plugins, util) ->
        $scope.expire_countdown = ''
        $scope.showReSend = false

        $scope.goBack = ($event) ->
            $event.preventDefault()
            backView = $ionicHistory.backView()

            console.log $rootScope.member.from
            if backView
                if backView.stateName == 'home.member.edit-mobile'
                    navigation.slide 'home.member.edit', {}, 'right'
                else
                    navigation.slide 'login', {}, 'right'
            else
                navigation.slide('home.dashboard', {}, 'right')

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
                        navigation.slide 'login', {}, 'right'
                        return
                    if $rootScope.member.from == 'edit-mobile'
                        navigation.slide 'home.member.edit', {}, 'right'
                        return

                navigation.slide 'login', {}, 'right'

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
            if number
                return "#{number.substring(0, 4)}***#{number.substring(number.length - 3, number.length)}"
            return

        $scope.resend = ($event) ->
            $event.preventDefault()

            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.member.phone_valid_expire = response.result
                $scope.showReSend = false

                getExpireCountdown()

            onError = () ->
                modal.hideLoading()

            member_id = $rootScope.member.memb_id
            api.resendVerifyCode(encodeURIComponent(member_id), onSuccess, onError)

        sendVerifyCode = (member_id, number) ->
            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.member.phone_valid_expire = response.result

            onError = () ->
                modal.hideLoading()

            api.sendValidPhone(encodeURIComponent(member_id), onSuccess, onError)

        getExpireCountdown = (datetime) ->
            if datetime and $rootScope.member
                $rootScope.member.phone_valid_expire = datetime
            doExpireCountdown = (datetime) ->
                now = moment()
                ms = moment(datetime, 'YYYY-MM-DDTHH:mm:ss').diff(now)
                d = moment.duration(ms)
                s = (Math.floor(d.asHours()) + moment.utc(ms).format(":mm:ss")).toString()

                $scope.showReSend = (ms <= 0)
                if util.startsWith s, '0:'
                    s = s.substr 2
                if $scope.showReSend
                    s = '00:00'

                $scope.expire_countdown = s

            if $rootScope.member and $rootScope.member.phone_valid_expire
                doExpireCountdown($rootScope.member.phone_valid_expire)

            if $scope.showReSend == false
                $timeout getExpireCountdown, 100

        getExpireCountdown()

        if $rootScope.member
            #console.log $rootScope.member
            if $rootScope.member.from == 'edit-mobile'
                $scope.mobile = $rootScope.member.new_memb_mobile
                return
            modal.showLoading '', 'message.processing'
            $scope.mobile = $rootScope.member.memb_mobile
            return sendVerifyCode($rootScope.member.memb_id, $scope.mobile)
        else
            navigation.slide 'login', {}, 'right'
]