module.exports = [
    '$scope', '$translate', 'navigation', 'plugins', 'modal', 'api',
    ($scope, $translate, navigation, plugins, modal, api) ->
        $scope.user = {}

        $scope.goBack = () ->
            navigation.slide('home.member.edit', {}, 'right')

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.member_name_edit', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.member_name_edit'],
                        translator['popup.ok']
                    )
                return

]