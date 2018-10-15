
module.exports = [
    '$rootScope', '$scope', '$ionicPlatform', '$cordovaBadge', '$window', '$timeout', '$log', '$translate', '$q',
    '$ionicScrollDelegate',
    'api', 'modal', 'navigation', 'plugins', 'user',
    ($rootScope, $scope, $ionicPlatform, $cordovaBadge, $window, $timeout, $log, $translate, $q,
        $ionicScrollDelegate,
        api, modal, navigation, plugins, user) ->
            deferred = $q.defer()

            modal.hideLoading()

            $scope.active = false

            $log.info('===============================')
            #$log.info(pullToRefresh)
            $log.info(window)
            $log.info($window)
            $log.info('===============================')

            #ptrContainer = document.querySelector('.pull-to-refresh-container .scroll')
            ptrContainer = document.querySelector('.ptr-container')
            ptrWrapper = document.querySelector('.ptr-container .ptr-wrapper')
            elScroll = document.querySelector('.pull-to-refresh-container > .scroll')
            
            pullToRefresh {
                container: ptrContainer
                wrapper: ptrWrapper
                animates: ptrAnimatesMaterial2
                threshold: 250
                fixTopWhenRefreshing: 60
                resetTopWhenPulling: elScroll

                refresh: () ->
                    $log.info 'refresh'
                    return new Promise (resolve) ->
                        $timeout(resolve, 1000 * 5) # mock 5 secs

                restore: () ->
                    # $log.info 'restore'
                    $ionicScrollDelegate.scrollTop()

                pulling: () ->
                    # $log.info 'pulling'
                    top = $ionicScrollDelegate.getScrollPosition().top
                    $log.info top
                    if top != 0
                        $ionicScrollDelegate.scrollTop()
            }

            $scope.goMemberDashboard = ->
                if not $scope.active
                    return

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
                    if response or response == 0
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

            switchToCourseInfo = (shop_id, prod_id) ->
                navigation.slide 'home.course.info', {shop_id: shop_id, prod_id: prod_id}, 'left'

            parseCourseNo = (data) ->
                regex = /sceapp:\/\/course\/(.+)/g
                if data and data.match
                    matches = regex.exec data
                    if matches.length == 2
                        return matches[1]
                return null

            window.handleOpenURL = (url) ->
                # url maybe like sceapp://course/8HI5_A6050
                # redirect state is : home.course.info
                setTimeout(() ->
                    #plugins.toast.show url, 'long', 'top'
                    course_no = parseCourseNo url
                    if course_no
                        switchToCourseInfo 'MS', course_no
                , 0)

            #handleOpenURL('sceapp://course/8HI5_A6050')

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
