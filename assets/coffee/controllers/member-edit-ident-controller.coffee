module.exports = [
    '$scope', '$ionicHistory', '$translate', 'navigation', 'plugins', 'modal', 'api',
    ($scope, $ionicHistory, $translate, navigation, plugins, modal, api) ->
        $scope.user = {}

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'down')
            else
                navigation.slide('home.dashboard', {}, 'down')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_ident_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_ident_edit'],
                        translator['popup.ok']
                    )
                return

            modal.showLoading '', 'message.data_saving'

            data = {
                'ident': $scope.user.ident_confirm
            }

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.goBack()
                $translate('message.data_saved').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = (error, status_code) ->
                modal.hideLoading()
                $translate('message.data_save_error').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
                console.log error
                console.log status_code

            api.updateMemberData(data, onSuccess, onError)
]