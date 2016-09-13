constants = require('../common/constants')

module.exports = ['$scope', '$log', ($scope, $log) ->
    def_locations = constants.LOCATIONS
    $scope.locations = {
        loc1: false,
        loc2: false,
        loc3: false,
        loc4: false,
        loc5: false,
        loc6: false
    }

    locations = JSON.parse(window.localStorage.getItem('locations'))
    if _.indexOf(locations, def_locations[0]) > -1
        $scope.locations.loc1 = true
    if _.indexOf(locations, def_locations[1]) > -1
        $scope.locations.loc2 = true
    if _.indexOf(locations, def_locations[2]) > -1
        $scope.locations.loc3 = true
    if _.indexOf(locations, def_locations[3]) > -1
        $scope.locations.loc4 = true
    if _.indexOf(locations, def_locations[4]) > -1
        $scope.locations.loc5 = true
    if _.indexOf(locations, def_locations[5]) > -1
        $scope.locations.loc6 = true
    $scope.taipei = true
    $scope.everywhere = true

    $scope.everywhereClick = (val) ->
        $scope.taipei = val
        $scope.locations = {
            loc1: val,
            loc2: val,
            loc3: val,
            loc4: val,
            loc5: val,
            loc6: val
        }
    $scope.taipeiClick = (val) ->
        $scope.locations = {
            loc1: val,
            loc2: val,
            loc3: val,
            loc4: val,
            loc5: $scope.locations.loc5,
            loc6: $scope.locations.loc6
        }


    $scope.locationConfirmClick = () ->
        $log.info $scope.locations

        locations = []
        if $scope.locations.loc1
            locations.push def_locations[0]
        if $scope.locations.loc2
            locations.push def_locations[1]
        if $scope.locations.loc3
            locations.push def_locations[2]
        if $scope.locations.loc4
            locations.push def_locations[3]
        if $scope.locations.loc5
            locations.push def_locations[4]
        if $scope.locations.loc6
            locations.push def_locations[5]

        # TODO : move locations from localStorage to $rootScope
        window.localStorage.setItem('locations', JSON.stringify(locations))
        $scope.$emit('locationConfirm')
        $scope.modalLocation.hide()

    return
]