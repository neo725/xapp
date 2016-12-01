constants = require('../common/constants')

module.exports = ['$scope', ($scope) ->
    def_locations = constants.LOCATIONS
    $scope.locations = {
        loc1: false,
        loc2: false,
        loc3: false,
        loc4: false,
        loc5: false,
        loc6: false
    }

    $scope.checkIsTaipeiChecked = () ->
        checked = true
        checked &= $scope.locations.loc1
        checked &= $scope.locations.loc2
        checked &= $scope.locations.loc3
        checked &= $scope.locations.loc4

        return checked

    $scope.checkIsEverywhereChecked = () ->
        checked = true
        checked &= $scope.locations.loc1
        checked &= $scope.locations.loc2
        checked &= $scope.locations.loc3
        checked &= $scope.locations.loc4
        checked &= $scope.locations.loc5
        checked &= $scope.locations.loc6

        return checked

    $scope.taipeiClick = (val) ->
        $scope.taipei = val
        $scope.locations = {
            loc1: val,
            loc2: val,
            loc3: val,
            loc4: val,
            loc5: $scope.locations.loc5,
            loc6: $scope.locations.loc6
        }

    $scope.everywhereClick = (val) ->
        $scope.locations = {
            loc1: val,
            loc2: val,
            loc3: val,
            loc4: val,
            loc5: val,
            loc6: val
        }

    $scope.locationConfirmClick = () ->
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

        if locations.length == 0
            locations = def_locations

        $scope.currentCover.location = locations.join(',')
        $scope.modalLocation.hide()

    $scope.$on('location:show', (event, args) ->
        locations = args.location.split(',')
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
    )
    return
]