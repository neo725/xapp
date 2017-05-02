module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicHistory', '$log', '$timeout',
    'navigation', 'modal', 'api', 'plugins', 'util', 'user',
    ($rootScope, $scope, $translate, $ionicHistory, $log, $timeout,
        navigation, modal, api, plugins, util, user) ->
            $scope.expire_countdown = ''
            $scope.showReSend = false
            $scope.input_data =
                verify_code = ''

            $scope.goBack = () ->
                backView = $ionicHistory.backView()

                if backView
                    if backView.stateName == 'home.member.edit-email'
                        navigation.slide 'home.member.edit', {}, 'right'
                    else
                        navigation.slide 'home.member.dashboard', {}, 'right'
                else
                    navigation.slide('home.member.dashboard', {}, 'right')

            $scope.submitForm = (form) ->
                if not form.$valid
                    $translate(['title.email_confirm', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                        plugins.notification.alert(
                            translator['errors.form_validate_error'],
                            (->),
                            translator['title.email_confirm'],
                            translator['popup.ok']
                        )
                    return

                onSuccess = (response) ->
                    modal.hideLoading()

                    modal.showMessage 'message.email_valid_pass'

                    if $rootScope.member
                        if $rootScope.member.from == 'edit-email'
                            navigation.slide 'home.member.edit', {}, 'right'
                            return

                    navigation.slide 'login', {}, 'right'

                onError = () ->
                    modal.hideLoading()

                action = ''
                if $rootScope.member.from == 'edit-email'
                    action = 'updatetel'

                data = {
                    'validcode': util.pad(form.verify_code.$modelValue, 4)
                    'membid': $rootScope.member.memb_id
                    'action': action
                }
                api.postPhoneValid(data, onSuccess, onError)

            $scope.resend = () ->
                member_id = $rootScope.member.memb_id
                return sendVerifyCode(member_id, true)

            sendVerifyCode = (member_id, resend = false) ->
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

                if resend
                    api.resendVerifyCode(member_id, onSuccess, onError)
                else
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
                if $rootScope.member.from == 'edit-email'
                    $scope.email = $rootScope.member.new_memb_email
                    getExpireCountdown()
                    return
                navigation.slide 'home.member.dashboard', {}, 'right'
]