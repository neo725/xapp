
module.exports = [
    '$scope', 'modal', 'navigation', ($scope, modal, navigation) ->
        modal.hideLoading()

        $scope.goMemberDashboard = ->
            navigation.slide 'home.member.dashboard', {}, 'left'

        $scope.goCatalogs = ->
            navigation.slide 'home.course.catalogs', {}, 'up'

        $scope.goEbookList = ->
            navigation.slide 'home.ebook.list', {}, 'left'

        $scope.goLocation = ->
            navigation.slide 'home.location', {}, 'left'
]