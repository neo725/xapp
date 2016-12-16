constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', 'navigation'
    ($rootScope, $scope, navigation) ->
        $scope.goNavigation = (location_name) ->
            if location_name
                navigation.slide 'home.location-map', { location: location_name }, 'left'
            $scope.modalCourseLocation.hide()

        $scope.$watch ->
                return $scope.currentCard
            , (card) ->
                if card
                    item = _.find(constants.LOCATIONS_MAPPING, { short_name: $scope.currentCard.Prod_ClsLocation })
                    if item
                        $scope.location_name = item.location_name
                        $scope.full_name = item.full_name
                        $scope.address = item.address
]