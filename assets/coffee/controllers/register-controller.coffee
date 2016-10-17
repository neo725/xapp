module.exports = [
    '$rootScope', '$scope', '$state', 'navigation', 'modal', 'api',
    ($rootScope, $scope, $state, navigation, modal, api) ->
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

            # register
            onSuccess = (response) ->
                modal.hideLoading()

                # login
                onSuccess = (response) ->
                    modal.hideLoading()
                    navigation.slide 'main.phoneconfirm', {}, 'left'
                onError = (error, status_code) ->
                    console.log 'login'
                    console.log status_code
                    console.log error

                    modal.hideLoading()
                    modal.showMessage 'errors.request_failed'

                data =
                    id: $scope.user.account
                    pw: $scope.user.password
                    device: ''

                api.login(data, onSuccess, onError)

            onError = (error, status_code) ->
                console.log 'register'
                console.log status_code
                console.log error

                modal.hideLoading()
                modal.showMessage 'errors.request_failed'

            data = {
                email: $scope.user.email
                name: $scope.user.name
                tel: $scope.user.mobile
                password: $scope.user.password
            }
            api.registerMember(data, onSuccess, onError)
]