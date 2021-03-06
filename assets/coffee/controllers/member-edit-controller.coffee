constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$ionicHistory', '$timeout', '$translate', '$log',
    'navigation', 'modal', 'plugins', 'api', 'user',
    ($rootScope, $scope, $ionicModal, $ionicHistory, $timeout, $translate, $log,
        navigation, modal, plugins, api, user) ->
            $scope.loaded = false
            $scope.user = {}

            $scope.goBack = ->
                navigation.slide 'home.member.dashboard', {}, 'right'

            $scope.goChangeName = ->
                navigation.slide 'home.member.edit-name', {}, 'left'

            $scope.goEditEmail = ->
                if $rootScope.member.memb_email
                    return
                navigation.slide 'home.member.edit-email', {}, 'left'

            $scope.checkIsEmailEmpty = ->
                return not $rootScope.member.memb_email

            $scope.goEditIdent = ->
                navigation.slide 'home.member.edit-ident', {}, 'left'

            $scope.goChangePassword = ->
                social_platform = user.getSocialPlatform()
                if social_platform
                    alertStopBySocialPlatform social_platform
                    return
                navigation.slide 'home.member.edit-pw-1', {}, 'left'

            $scope.goChangeMobile = ->
                navigation.slide 'home.member.edit-mobile', {}, 'left'

            $scope.doSubmit = ($event) ->
                $event.stopPropagation()
                $timeout(->
                    #$('form').submit()
                    $('#submitButton').click()
                )

            $scope.submitForm = (form) ->
    #            console.log '$scope.user :'
    #            console.log $scope.user
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


            alertStopBySocialPlatform = (social_platform) ->
                params = {}
                switch social_platform
                    when 'facebook'
                        params.social_platform_name = 'Facebook'
                    when 'google'
                        params.social_platform_name = 'Google'

                $translate(['title.member_password_edit', 'message.password_cant_edit_with_social_login', 'popup.ok'], params).then (translator) ->
                    plugins.notification.alert(
                        translator['message.password_cant_edit_with_social_login'],
                        (->),
                        translator['title.member_password_edit'],
                        translator['popup.ok']
                    )

            updateMember = () ->
                modal.showLoading '', 'message.data_saving'

                data = {
                    'gender': $scope.user.memb_gender
                    'birth': "#{$scope.user.birth_year}-#{$scope.user.birth_month}-#{$scope.user.birth_day}"
                    'address': $scope.user.memb_address
                }

                onSuccess = (response) ->
                    modal.hideLoading()
                    $translate('message.data_saved').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                onError = () ->
                    modal.hideLoading()

                api.updateMemberData(data, onSuccess, onError)

            loadData = ->
    #            saved_card = JSON.parse(window.localStorage.getItem('saved_card')) || {}
    #            if saved_card.card
    #                $scope.cards = [saved_card.card]
    #            else
    #                $scope.cards = []
                onSuccess = (data) ->
                    birthday = moment(data.memb_birthday, 'YYYY-MM-DD')
                    data.birth_year = birthday.get('year')
                    data.birth_month = parseInt(birthday.format('MM'))
                    data.birth_day = parseInt(birthday.format('DD'))

                    $scope.user = data
                    $scope.loaded = true

                onError = (->)

                $scope.loaded = false
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
                if not $rootScope.member
                    loadData()
            )
            init()
            loadData()

            $ionicModal.fromTemplateUrl('templates/modal-new-card.html',
                scope: $scope
                animation: 'slide-in-up'
            ).then((modal) ->
                $scope.modalNewCard = modal
            )
]