constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$timeout', '$translate', 'navigation', 'modal', 'plugins', 'api',
    ($rootScope, $scope, $ionicModal, $timeout, $translate, navigation, modal, plugins, api) ->
        $scope.user = {}
        $scope.notify = constants.DEFAULT_NOTIFICATION_SETTING

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'down'

        $scope.goEditIdent = ->
            navigation.slide 'home.member.edit-ident', {}, 'up'

        $scope.goChangePassword = ->
            navigation.slide 'home.member.edit-pw-1', {}, 'up'

        $scope.goChangeMobile = ->
            navigation.slide 'home.member.edit-mobile', {}, 'up'

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

#        $scope.checkCardType = (number) ->
#            return util.checkCardType(number)
#
#        $scope.showNewCard = ->
#            $scope.modalNewCard.show()
#
#        $scope.onItemDelete = (card) ->
#            $scope.cards.splice($scope.cards.indexOf(card), 1)
#
#            cards = [JSON.parse(window.localStorage.getItem('saved_card'))]
#            cards.splice(cards.indexOf(card))
#
#            if cards.length == 0
#                window.localStorage.removeItem('saved_card')
#            else
#                window.localStorage.setItem('saved_card', JSON.stringify(cards[0]))

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
            onError = (error, status_code) ->
                console.log 'updateMember.error'
                console.log error
                console.log status_code

            api.updateMemberData(data, onSuccess, onError)

        loadData = ->
#            saved_card = JSON.parse(window.localStorage.getItem('saved_card')) || {}
#            if saved_card.card
#                $scope.cards = [saved_card.card]
#            else
#                $scope.cards = []

            loadUserSetting = ->
                onSuccess = (response) ->
                    if (response != null)
                        $scope.notify = response.para_value
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