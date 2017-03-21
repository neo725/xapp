module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicHistory', '$log', '$timeout', 'navigation', 'modal', 'api', 'plugins', 'util',
    ($rootScope, $scope, $translate, $ionicHistory, $log, $timeout, navigation, modal, api, plugins, util) ->
        $scope.expire_countdown = ''
        $scope.showReSend = false
        $scope.input_data =
            verify_code = ''

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            window.sessionStorage.removeItem('token')

            if backView
                if backView.stateName == 'home.member.edit-mobile'
                    navigation.slide 'home.member.edit', {}, 'right'
                else
                    navigation.slide 'login', {}, 'right'
            else
                navigation.slide('login', {}, 'right')

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

                modal.showMessage 'message.phone_valid_pass'

                #if $rootScope.token_temp
                #    window.localStorage.setItem("token", $rootScope.token_temp)
                token = window.sessionStorage.getItem('token')
                if token != null
                    window.localStorage.setItem('token', token)
                    window.sessionStorage.removeItem('token')

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

        $scope.resend = () ->
            member_id = $rootScope.member.memb_id
            return sendVerifyCode(member_id)

        sendVerifyCode = (member_id) ->
            $scope.input_data.verify_code = ''

            callGetExpireCountdown = (seconds) ->
                $rootScope.member.verify_resend_expire = util.getMomentNowAddSeconds(seconds)
                $scope.showReSend = false
                $log.info 'seconds : ' + seconds
                $log.info 'verify_resend_expire :'
                $log.info $rootScope.member.verify_resend_expire

                getExpireCountdown()

            onSuccess = (response) ->
                modal.hideLoading()
                seconds = parseInt(response.result)

                callGetExpireCountdown(seconds)

            onError = (error, status_code) ->
                modal.hideLoading()
                if status_code == 405
                    seconds = parseInt(error.result)

                    callGetExpireCountdown(seconds)

            api.sendValidPhone(encodeURIComponent(member_id), onSuccess, onError)

        getExpireCountdown = (expire) ->

            if expire and $rootScope.member
                $rootScope.member.verify_resend_expire = expire

            doExpireCountdown = (expire) ->
                now = util.getMomentNow()
                ms = expire.diff(now)
                d = moment.duration(ms)
                s = (Math.floor(d.asHours()) + moment.utc(ms).format(":mm:ss")).toString()

                $scope.showReSend = (ms < 1000)
                if util.startsWith s, '0:'
                    s = s.substr 2
                if $scope.showReSend
                    s = '00:00'

                $scope.expire_countdown = s

                return ms / 1000

            if $rootScope.member and $rootScope.member.verify_resend_expire
                doExpireCountdown($rootScope.member.verify_resend_expire)

            if $scope.showReSend == false
                $timeout ->
                    getExpireCountdown()
                , 1000

        if $rootScope.member
            if $rootScope.member.from == 'edit-mobile'
                $scope.mobile = $rootScope.member.new_memb_mobile
                getExpireCountdown()
                return
            modal.showLoading '', 'message.processing'
            $scope.mobile = $rootScope.member.memb_mobile
            return sendVerifyCode($rootScope.member.memb_id, $scope.mobile)
        else
            navigation.slide 'login', {}, 'right'
]