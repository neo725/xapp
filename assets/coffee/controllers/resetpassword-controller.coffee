module.exports = [
    '$rootScope', '$scope', '$translate', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $translate, navigation, modal, api, plugins) ->
        $scope.receive_data = 'thchang@sce.pccu.edu.tw'
        $scope.user =
            email: ''
            valid_code: ''
            password: ''

        $scope.goBack = () ->
            navigation.slide 'login', {}, 'right'
]