module.exports = ['$scope', '$sce', 'navigation', 'api',
    ($scope, $sce, navigation, api) ->

        $scope.goBack = () ->
            navigation.slide 'home.member.cart.step1', {}, 'right'

        $scope.parseHTML = (str) ->
            if str
                return str.replace(/(?:\r\n|\r|\n)/g, '<br />')
            return str

        loadRefund = () ->
            onSuccess = (response) ->
                $scope.rule = response
            onError = (->)

            api.getRefund(onSuccess, onError)

        loadRefund()
]