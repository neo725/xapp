module.exports = [
    '$rootScope', '$scope', '$ionicModal', 'navigation', 'modal', 'api',
    ($rootScope, $scope, $ionicModal, navigation, modal, api) ->
        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'down'

        $scope.changePassword = ($event) ->
            $event.stopPropagation()

            $scope.modalChangePassword.show()

        $scope.changePasswordConfirmClick = ->
            $scope.modalChangePassword.hide()


        $ionicModal.fromTemplateUrl('templates/modal-change-password.html',
            scope: $scope
            animation: 'slide-in-up'
        ).then((modal) ->
            $scope.modalChangePassword = modal
        )
]