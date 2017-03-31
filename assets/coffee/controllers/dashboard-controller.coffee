
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', '$cordovaBadge', '$window', '$timeout', '$log', '$translate',
    'api', 'modal', 'navigation', 'plugins', 'user',
    ($rootScope, $scope, $ionicPlatform, $cordovaBadge, $window, $timeout, $log, $translate,
        api, modal, navigation, plugins, user) ->
            modal.hideLoading()

            #$rootScope.loadSearchSlide = false
            #$rootScope.loadStudycardSlide = false
            $scope.active = false


            $scope.goMemberDashboard = ->
                if not $scope.active
                    return

#                is_guest = user.isGuest()
#
#                if is_guest
#                    return $rootScope.logout()
#                else
#                    navigation.slide 'home.member.dashboard', {}, 'left'
                navigation.slide 'home.member.dashboard', {}, 'left'

            $scope.goCatalogs = ->
                navigation.slide 'home.course.catalogs', {}, 'left'

            $scope.goEbookList = ->
                navigation.slide 'home.ebook.list', {}, 'left'

            $scope.goLocation = ->
                navigation.slide 'home.location', {}, 'left'

            loadAvatar = ->
                onSuccess = (response) ->
                    if response
                        $rootScope.avatar_url = response.para_value
                onError = (->)

                api.getUserSetting 'avatar', onSuccess, onError

            loadNotifyData = ->
                onSuccess = (response) ->
                    if (response != null)
                        $rootScope.notify = response.para_value
                onError = (->)

                api.getUserSetting 'notify', onSuccess, onError

            loadUnreadMessageCount = ->
                onSuccess = (response) ->
                    $rootScope.unread_message_count = 0
                    if response and window.cordova
                        $rootScope.unread_message_count = parseInt(response)
                        $cordovaBadge.set $rootScope.unread_message_count
                onError = ->
                    $rootScope.unread_message_count = 0
                    $cordovaBadge.clear()

                api.getUnreadMessageCount onSuccess, onError

            loadNotifyData()
            loadAvatar()
            loadUnreadMessageCount()

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