
module.exports = [
    '$scope', 'modal', 'navigation', ($scope, modal, navigation) ->
        modal.hideLoading()

        $scope.goMemberDashboard = ->
            navigation.slide 'home.member.dashboard', {}, 'left'

        $scope.goCatalogs = ->
            navigation.slide 'home.course.catalogs', {}, 'up'

        $scope.goCart = ->
            navigation.slide 'home.member.cart.step1', {}, 'top'
]