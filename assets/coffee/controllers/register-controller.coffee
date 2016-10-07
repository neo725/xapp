module.exports = [
    '$rootScope', '$scope', '$state', 'navigation', 'modal',
    ($rootScope, $scope, $state, navigation, modal) ->
        $scope.goBack = () ->
            navigation.slide 'login', {}, 'down'

        $scope.submitForm = (form) ->
            if not form.$valid
                modal.showMessage 'errors.form_validate_error'
                return

            console.log $scope.user
]