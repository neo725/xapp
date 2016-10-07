module.exports = [
    '$rootScope', '$scope', 'navigation', 'modal', ($rootScope, $scope, navigation, modal) ->
        $scope.goBack = () ->
            navigation.slide 'login', {}, 'down'

        $scope.submitForm = (form) ->
            if not form.$valid
                modal.showMessage 'errors.form_validate_error'
                return

            console.log form

        $scope.maskNumber = (number) ->
            return "#{number.substring(0, 4)}***#{number.substring(number.length - 3, number.length)}"

        sendVerifyCode = (number) ->
            return number

        if $rootScope.user
            $scope.mobile = $rootScope.user.mobile
            return sendVerifyCode($scope.mobile)

        navigation.slide 'login', {}, 'down'
]