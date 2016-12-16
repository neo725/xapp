constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$cordovaLaunchNavigator'
    ($rootScope, $scope, $cordovaLaunchNavigator) ->
        $scope.goNavigation = (card) ->
            if not card
                return

            item = _.find(constants.LOCATIONS_MAPPING, { short_name: card.Prod_ClsLocation })

            $cordovaLaunchNavigator.navigate item.address, {}

            $scope.modalCourseLocation.hide()
]