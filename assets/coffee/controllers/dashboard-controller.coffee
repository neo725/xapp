
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', '$cordovaBadge', '$window', '$timeout', '$log', '$translate', '$q',
    'api', 'modal', 'navigation', 'plugins', 'user',
    ($rootScope, $scope, $ionicPlatform, $cordovaBadge, $window, $timeout, $log, $translate, $q,
        api, modal, navigation, plugins, user) ->
            deferred = $q.defer()

            modal.hideLoading()

            #$rootScope.loadSearchSlide = false
            #$rootScope.loadStudycardSlide = false
            $scope.active = false


            $scope.goMemberDashboard = ->
                if not $scope.active
                    return

#                is_guest = user.getIsGuest()
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

            $scope.doRefresh = () ->
                $scope.$broadcast('dashboard.doRefresh')
                $scope.$broadcast('scroll.refreshComplete')

            loadAvatar = ->
                onSuccess = (response) ->
                    if not response
                        $rootScope.avatar_url = null
                    else
                        $rootScope.avatar_url = response.para_value
                onError = (->)

                api.getUserSetting 'avatar', onSuccess, onError

            loadNotifyData = ->
                onSuccess = (response) ->
                    if (response != null)
                        $rootScope.notify = response.para_value
                onError = (->)

                api.getUserSetting 'notify', onSuccess, onError

            detectWhenPlatformReady = () ->
                return deferred.promise

            loadUnreadMessageCount = ->
                onSuccess = (response) ->
                    $rootScope.unread_message_count = 0
                    if response
                        $rootScope.unread_message_count = parseInt(response)
                        success = () ->
                            if window.cordova and cordova.plugins
                                $cordovaBadge.set $rootScope.unread_message_count
                        detectWhenPlatformReady().then(success, (->))

                onError = ->
                    $rootScope.unread_message_count = 0
                    success = () ->
                        if window.cordova and cordova.plugins
                            $cordovaBadge.clear()
                    detectWhenPlatformReady().then(success, (->))

                api.getUnreadMessageCount onSuccess, onError


            window.handleOpenURL = (url) ->
                setTimeout(() ->
                    plugins.toast.show url, 'long', 'top'
                , 0)

#            url_open = window.sessionStorage.getItem('url-open')
#            if (url_open)
#                plugins.toast.show url_open, 'long', 'top'

            if user.getIsGuest() == false
                loadNotifyData()
                loadAvatar()
                loadUnreadMessageCount()

            $rootScope.loadCart()
            $rootScope.loadWish()

            document.addEventListener('deviceready', () ->
                $log.info 'dashboard-controller -> device ready...'
            , false)

            $ionicPlatform.ready(->
                $log.info 'dashboard-controller -> ionicPlatform ready...'
                deferred.resolve()
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