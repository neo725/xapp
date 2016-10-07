module.exports = [
    '$rootScope', '$scope', '$state', 'navigation', 'modal',
    ($rootScope, $scope, $state, navigation, modal) ->
        $scope.user = {
            name: 'Neo Chang'
            account: 'neochang'
            email: 'thchang@sce.pccu.edu.tw'
            email_confirm: 'thchang@sce.pccu.edu.tw'
            password: '1234'
            password_confirm: '1234'
            mobile: '0986-716-086'
        }

        $scope.goBack = () ->
            navigation.slide 'login', {}, 'down'

        $scope.submitForm = (form) ->
            if not form.$valid
                modal.showMessage 'errors.form_validate_error'
                return

            $scope.user.mobile = $scope.user.mobile.replace(new RegExp('-', 'g'), '')
            $rootScope.user = $scope.user
            navigation.slide 'main.phoneconfirm', {}, 'left'
]