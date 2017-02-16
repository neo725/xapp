
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', '$window', '$timeout', '$log', 'modal', 'navigation',
    ($rootScope, $scope, $ionicPlatform, $window, $timeout, $log, modal, navigation) ->
        modal.hideLoading()

        #$rootScope.loadSearchSlide = false
        #$rootScope.loadStudycardSlide = false
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
            $log.info 'dashboard-controller -> device ready...'
        , false)

        $ionicPlatform.ready(->
            $log.info 'dashboard-controller -> ionicPlatform ready...'
        )

        $scope.$on('$ionicView.enter', ->
            $log.info 'dashboard-controller -> $ionicView.enter'

            $scope.$broadcast 'dashboard-controller.enter'
        )
        $scope.$on('$ionicView.afterEnter', ->
            $log.info 'dashboard-controller -> $ionicView.afterEnter'
            $scope.$broadcast 'dashboard-controller.afterEnter'

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
            $log.info 'window width : ' + value
        $scope.$watch ->
            return $window.innerHeight
        , (value) ->
            $log.info 'window height : ' + value
]