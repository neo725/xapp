module.exports = ['$scope', '$sce', 'navigation', 'api',
    ($scope, $sce, navigation, api) ->

        $scope.goBack = () ->
            navigation.slide 'login', {}, 'right'

        $scope.parseHTML = (str) ->
            if str
                return str.replace(/(?:\r\n|\r|\n)/g, '<br />')
            return str

        loadRule = () ->
            onSuccess = (response) ->
                $scope.rule = response
            onError = (->)

            api.getServiceRule(onSuccess, onError)

        loadRule()
]