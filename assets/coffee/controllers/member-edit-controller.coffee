constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$timeout', '$translate', 'navigation', 'modal', 'plugins', 'api', 'util',
    ($rootScope, $scope, $ionicModal, $timeout, $translate, navigation, modal, plugins, api, util) ->
        $scope.user = {}
        $scope.setting = {}
        $scope.setting.notify = constants.DEFAULT_NOTIFICATION_SETTING

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'down'

        $scope.changePassword = ($event) ->
            $event.stopPropagation()
            $scope.modalChangePassword.show()

        $scope.changePasswordConfirmClick = ->
            $scope.modalChangePassword.hide()

        $scope.toggleNotification = ($event) ->
            $event.stopPropagation()
            if $scope.setting.notify == 't'
                $scope.setting.notify = 'f'
            else
                $scope.setting.notify = 't'

        $scope.checkNotificationIsChecked = ->
            if $scope.setting.notify != 'f'
                $scope.setting.notify = 't'
            return $scope.setting.notify == 't'

        $scope.doSubmit = ($event) ->
            $event.stopPropagation()
            $timeout(->
                #$('form').submit()
                $('#submitButton').click()
            )

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_edit'],
                        translator['popup.ok']
                    )
                return

            updateMember()

        $scope.checkCardType = (number) ->
            return util.checkCardType(number)

        $scope.showNewCard = ->
            $scope.modalNewCard.show()

        $scope.onItemDelete = (card) ->
            $scope.cards.splice($scope.cards.indexOf(card), 1)

            cards = [JSON.parse(window.localStorage.getItem('saved_card'))]
            cards.splice(cards.indexOf(card))

            if cards.length == 0
                window.localStorage.removeItem('saved_card')
            else
                window.localStorage.setItem('saved_card', JSON.stringify(cards[0]))

        updatePassword = (saving_passed) ->
            finish = (passed) ->
                modal.hideLoading()
                if passed
                    $translate('message.data_saved').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                    $scope.goBack()
                else
                    $translate(['title.member_edit', 'errors.setting_save_error', 'popup.ok']).then (translator) ->
                        plugins.notification.alert(
                            translator['errors.setting_save_error'],
                            (->),
                            translator['title.member_edit'],
                            translator['popup.ok']
                        )

            if $scope.setting.confirm_new_password
                data =
                    'oldPW': $scope.setting.current_password
                    'newPW': $scope.setting.confirm_new_password
                console.log 'updatePassword...'
                console.log data
                onSuccess = (response) ->
                    console.log 'updatePassword.success'
                    finish(saving_passed)
                onError = (error, status_code) ->
                    switch status_code
                        when 405
                            $translate(['title.member_edit', 'errors.current_password_error', 'popup.ok']).then (translator) ->
                                plugins.notification.alert(
                                    translator['errors.current_password_error'],
                                    (->),
                                    translator['title.member_edit'],
                                    translator['popup.ok']
                                )
                    console.log 'updatePassword.error'
                    console.log error
                    console.log status_code
                    finish(saving_passed)

                api.updatePassword(data, onSuccess, onError)
            else
                finish(saving_passed)

        updateSetting = (saving_passed) ->
            data =
                'notify': 't'
            data.notify = 'f' if $scope.checkNotificationIsChecked() == false

            console.log 'updateSetting...'
            console.log data
            onSuccess = (response) ->
                console.log 'updateSetting.success'
                updatePassword(saving_passed and true)
            onError = (error, status_code) ->
                console.log 'updateSetting.error'
                console.log error
                console.log status_code
                updatePassword(false)

            api.postUserSetting('notify', "'#{data.notify}'", onSuccess, onError)

        updateMember = () ->
            modal.showLoading '', 'message.data_saving'

            data = {
                'name': $scope.user.memb_name
                'tel': $scope.user.memb_mobile
                'mail': $scope.user.memb_email
                'ident': $scope.user.memb_ident
            }

            console.log 'updateMember...'
            console.log data
            onSuccess = (response) ->
                console.log 'updateMember.success'
                updateSetting(true)
            onError = (error, status_code) ->
                console.log 'updateMember.error'
                console.log error
                console.log status_code
                updateSetting(false)

            api.updateMemberData(data, onSuccess, onError)

        loadData = ->
            saved_card = JSON.parse(window.localStorage.getItem('saved_card')) || {}
            if saved_card.card
                $scope.cards = [saved_card.card]
            else
                $scope.cards = []

            resetPasswordField = ->
                $scope.setting.current_password = ''
                $scope.setting.new_password = ''
                $scope.setting.confirm_new_password = ''

            loadUserSetting = ->
                onSuccess = (response) ->
                    if (response != null)
                        $scope.setting.notify = response.para_value
                    modal.hideLoading()

                onError = (error, status_code) ->
                    console.log status_code
                    console.log error
                    modal.hideLoading()

                api.getUserSetting 'notify', onSuccess, onError

            onSuccess = (data) ->
                $scope.user = data
                loadUserSetting()

            onError = (error, status_code) ->
                console.log status_code
                console.log error
                loadUserSetting()

            resetPasswordField()
            $rootScope.getMemberData(onSuccess, onError)

        init = ->
            birth_year_opts = []
            year = new Date().getFullYear()
            limit_year = year - 100
            while year > limit_year
                birth_year_opts.push year
                year--
            $scope.birth_year_opts = birth_year_opts

            birth_month_opts = []
            month = 1
            limit_month = 12
            while month <= limit_month
                birth_month_opts.push month
                month++
            $scope.birth_month_opts = birth_month_opts

            birth_day_opts = []
            day = 1
            limit_day = 31
            while day <= limit_day
                birth_day_opts.push day
                day++
            $scope.birth_day_opts = birth_day_opts

        $scope.$on('$ionicView.enter', ->
            init()
            loadData()
        )

        $ionicModal.fromTemplateUrl('templates/modal-new-card.html',
            scope: $scope
            animation: 'slide-in-up'
        ).then((modal) ->
            $scope.modalNewCard = modal
        )
]