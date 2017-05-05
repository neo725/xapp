module.exports = [
    '$rootScope', '$scope', '$translate', '$log', 'navigation', 'plugins', 'modal', 'api', 'util',
    ($rootScope, $scope, $translate, $log, navigation, plugins, modal, api, util) ->
        $scope.user = {}

        $scope.goBack = () ->
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
                $rootScope.member.verify_resend_expire = util.getMomentNowAddSeconds(seconds)

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

        trimStart = (character, string) ->
            startIndex = 0
            while string[startIndex] == character
                startIndex++
            return string.substr(startIndex)

        proccessPhoneNumber = (number) ->
            return parseInt(trimStart('+', number))

        readSimInfo = () ->
            successCallback = (info) ->
                if info and info.phoneNumber
                    $scope.user.memb_mobile = proccessPhoneNumber(info.phoneNumber)
            window.plugins.sim.getSimInfo successCallback, (->)

        requestReadPermission = (successCallback) ->
            window.plugins.sim.requestReadPermission(successCallback, (->))

        onDeviceReady = () ->
            if window.plugins and window.plugins.sim
                requestReadPermission readSimInfo

        document.addEventListener('deviceready', onDeviceReady, false)
]