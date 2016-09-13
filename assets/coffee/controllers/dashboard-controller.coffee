
module.exports = ['$scope', 'modal', 'navigation', 'api', ($scope, modal, navigation, api) ->
    modal.hideLoading()

    $scope.goMemberDashboard = ->
        navigation.slide 'home.member.dashboard', {}, 'left'

    $scope.goCatalogs = ->
        navigation.slide 'home.course.catalogs', {}, 'up'
]