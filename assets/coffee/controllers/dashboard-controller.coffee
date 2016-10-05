
module.exports = [
    '$scope', 'modal', 'navigation', ($scope, modal, navigation) ->
        modal.hideLoading()

        $scope.goMemberDashboard = ->
            navigation.slide 'home.member.dashboard', {}, 'left'

        $scope.goCatalogs = ->
            navigation.slide 'home.course.catalogs', {}, 'up'
]