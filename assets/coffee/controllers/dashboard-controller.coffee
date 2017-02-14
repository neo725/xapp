
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', '$window', '$timeout', 'modal', 'navigation',
    ($rootScope, $scope, $ionicPlatform, $window, $timeout, modal, navigation) ->
        modal.hideLoading()
        $scope.active = false

        $scope.goMemberDashboard = ->
            if not $scope.active
                return

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
            $timeout ->
                $scope.active = true
            , 1000
        )
        $scope.$on('$ionicView.leave', ->
            $scope.active = false
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