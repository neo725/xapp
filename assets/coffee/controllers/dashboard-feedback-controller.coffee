module.exports = [
    '$scope', ($scope) ->
        $scope.rating1 = 1
        $scope.rating2 = 2
        $scope.rating3 = 3

        $scope.rateFunction = (ratingVarName, rating) ->
            switch ratingVarName
                when 'rating1'
                    $scope.rating1 = rating
                when 'rating2'
                    $scope.rating2 = rating
                when 'rating3'
                    $scope.rating3 = rating

            console.log $scope.rating1
            console.log $scope.rating2
            console.log $scope.rating3

        $scope.submitFeedback = () ->
            console.log $scope.currentCard
            console.log $scope.rating1
            console.log $scope.rating2
            console.log $scope.rating3

            $scope.modalFeedback.hide()
]