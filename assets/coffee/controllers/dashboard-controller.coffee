
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', 'modal', 'navigation',
    ($rootScope, $scope, $ionicPlatform, modal, navigation) ->
        modal.hideLoading()

        $scope.goMemberDashboard = ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'

            if is_guest
                return $rootScope.logout()
            else
                navigation.slide 'home.member.dashboard', {}, 'left'

        $scope.goCatalogs = ->
            navigation.slide 'home.course.catalogs', {}, 'up'

        $scope.goEbookList = ->
            navigation.slide 'home.ebook.list', {}, 'left'

        $scope.goLocation = ->
            navigation.slide 'home.location', {}, 'left'

        document.addEventListener('deviceready', () ->
            console.log 'device ready...'
        , false)

        $ionicPlatform.ready(->
            console.log 'ionicPlatform ready...'
        )

        $scope.$on('$ionicView.enter', ->
            console.log '$ionicView.enter'
        )
        $scope.$on('$ionicView.afterEnter', ->
            console.log '$ionicView.afterEnter'
        )
]