module.exports = [
    '$scope', '$translate', 'navigation', 'modal', 'plugins', 'api',
    ($scope, $translate, navigation, modal, plugins, api) ->
        $scope.type_opts = [
            '支持與鼓勵 (Encouragement)',
            '意見反應 (Suggestion)'
        ]
        $scope.reply_opts = [
            '不須回覆 (No need to reply)',
            '僅以 Email 回覆 (By email)'
            '專人 24 小時內致電 (回電時間為工作日 10:00~19:00)(By phone)'
        ]
        $scope.suggestion = {}

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'down'

        $scope.submitForm = (form) ->
            if not form.$valid
                #modal.showLongMessage 'errors.form_validate_error'
                $translate(['title.suggestion', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.suggestion'],
                        translator['popup.ok']
                    )
                return

            onSuccess = (response) ->
                modal.hideLoading()
                navigation.slide 'home.member.dashboard', {}, 'down'
                $translate('message.suggestion_sended').then (text) ->
                    plugins.toast.show(text, 'long', 'top')

            onError = (error, status_code) ->
                modal.hideLoading()
                modal.showMessage 'errors.request_failed'

            data =
                'name': $scope.suggestion.username
                'tel': $scope.suggestion.telphone
                'email': $scope.suggestion.email
                'type': $scope.suggestion.type
                'reply': $scope.suggestion.reply
                'info': $scope.suggestion.opinion

            modal.showLoading('', 'message.post_suggestion')
            api.postSuggestion(data, onSuccess, onError)
]