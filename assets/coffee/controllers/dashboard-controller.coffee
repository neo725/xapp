
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', '$window', 'modal', 'navigation',
    ($rootScope, $scope, $ionicPlatform, $window, modal, navigation) ->
        modal.hideLoading()

        $scope.goMemberDashboard = ->
            is_guest = window.localStorage.getItem('is_guest') == 'true'

            if is_guest
                return $rootScope.logout()
            else
                navigation.slide 'home.member.dashboard', {}, 'left'

        $scope.goCatalogs = ->
            navigation.slide 'home.course.catalogs', {}, 'left'

        $scope.goEbookList = ->
            navigation.slide 'home.ebook.list', {}, 'left'

        $scope.goLocation = ->
            navigation.slide 'home.location', {}, 'left'

        document.addEventListener('deviceready', () ->
            console.log 'dashboard-controller -> device ready...'
        , false)

        $ionicPlatform.ready(->
            console.log 'dashboard-controller -> ionicPlatform ready...'
        )

        $scope.$on('$ionicView.enter', ->
            console.log 'dashboard-controller -> $ionicView.enter'
        )
        $scope.$on('$ionicView.afterEnter', ->
            console.log 'dashboard-controller -> $ionicView.afterEnter'
        )

        $scope.$watch ->
            return $window.innerWidth
        , (value) ->
            console.log 'window width : ' + value
        $scope.$watch ->
            return $window.innerHeight
        , (value) ->
            console.log 'window height : ' + value
]