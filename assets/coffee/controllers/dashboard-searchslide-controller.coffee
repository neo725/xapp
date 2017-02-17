constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicSlideBoxDelegate', '$ionicModal', '$timeout', '$log',
    'api', 'modal', 'navigation', 'user',
    ($rootScope, $scope, $ionicSlideBoxDelegate, $ionicModal, $timeout, $log, api, modal, navigation, user) ->
        loadSearchSlide = (showLoading) ->
            if not showLoading == false
                showLoading = true

            $log.info '[** SearchSlide **] >> loadSearchSlide()......'

            onSuccess = (response) ->
                if showLoading
                    modal.hideLoading()
                $log.warn '[** SearchSlide **] >> $(".search-slides").show() ......'
                $log.info $('.search-slides')
                $('.search-slides').show()

                list = response.list
                $scope.covers = list
                $rootScope.loadSearchSlide = false

                $timeout(->
                    $ionicSlideBoxDelegate.update()
                    $ionicSlideBoxDelegate.$getByHandle('search-slide-box').loop(true)
                , 500)

                $rootScope.loadCart()
                $rootScope.loadWish()

            onError = () ->
                if showLoading
                    modal.hideLoading()

            if showLoading
                modal.showLoading '', 'message.loading_cover'
            api.getCover(onSuccess, onError)

        $('.search-slides').hide()

        $scope.$on('dashboard-controller.enter', () ->
            $log.info '[** SearchSlide **] >> dashboard-controller.enter  ......'
            $log.info '[** SearchSlide **] >> $rootScope.fromNotification : ' + $rootScope.fromNotification
            $log.info '[** SearchSlide **] >> $rootScope.loadSearchSlide : ' + $rootScope.loadSearchSlide

            if $rootScope.fromNotification
                if user.isGuest()
                    $rootScope.fromNotification = not $rootScope.loadSearchSlide
                else
                    $rootScope.fromNotification = not ($rootScope.loadStudycardSlide and $rootScope.loadSearchSlide)

                #$rootScope.loadSearchSlide = true
                $ionicSlideBoxDelegate.update()

#            if $rootScope.loadSearchSlide
#                #token = window.localStorage.getItem('token')
#                #if $rootScope.member or token
#                #    loadSearchSlide()
#                loadSearchSlide()
        )
        $scope.$on('index-controller.onNotificationRegistered', () ->
            $log.info '{** SearchSlide **} >> index-controller.onNotificationRegistered......'
            $rootScope.onNotificationRegistered = true
#            $log.info '[** SearchSlide **] >> $rootScope.fromNotification : ' + $rootScope.fromNotification
#            $log.info '[** SearchSlide **] >> $rootScope.loadStudycardSlide : ' + $rootScope.loadStudycardSlide
#            $log.info '[** SearchSlide **] >> $rootScope.loadSearchSlide : ' + $rootScope.loadSearchSlide
#            $log.info '[** SearchSlide **] >> isGuest : ' + user.isGuest()
#            $log.info '[** SearchSlide **] >> isRealDevice : ' + user.isRealDevice()
            loadSearchSlide(false)
        )
#        token = window.localStorage.getItem('token')
#        if $rootScope.member or token
#            loadSearchSlide()
#        $log.info '[** SearchSlide **] >> loadSearchSlide()'
#        $log.info '[** SearchSlide **] >> $rootScope.fromNotification : ' + $rootScope.fromNotification
#        $log.info '[** SearchSlide **] >> $rootScope.loadStudycardSlide : ' + $rootScope.loadStudycardSlide
#        $log.info '[** SearchSlide **] >> $rootScope.loadSearchSlide : ' + $rootScope.loadSearchSlide
#        $log.info '[** SearchSlide **] >> isGuest : ' + user.isGuest()
        $log.info '[** SearchSlide **] >> isRealDevice : ' + user.isRealDevice()
        if user.isGuest() or not user.isRealDevice()
            loadSearchSlide()

        $scope.searchCourse = (cover) ->
            weeks = cover.week.split(',')
            locations = cover.location.split(',')
            window.localStorage.setItem('weekdays', JSON.stringify(weeks))
            window.localStorage.setItem('locations', JSON.stringify(locations))

            navigation.slide 'home.course.search', { keyword: cover.user_keyword }, 'left'

        # modal controller
        # ------------------------------------------------
        $scope.showWeekdayModal = (cover) ->
            $scope.currentCover = cover
            $scope.$broadcast('weekday:show', cover)
            $scope.modalWeekday.show()

        $scope.showLocationModal = (cover) ->
            $scope.currentCover = cover
            $scope.$broadcast('location:show', cover)
            $scope.modalLocation.show()

        $scope.parseWeekday = (weekdays) ->
            weekdays = weekdays.split(',')
            if weekdays.length == 0
                weekdays = constants.WEEKDAYS
            totalCount = 0
            totalCount += 1 if _.indexOf(weekdays, '一') != -1
            totalCount += 1 if _.indexOf(weekdays, '二') != -1
            totalCount += 1 if _.indexOf(weekdays, '三') != -1
            totalCount += 1 if _.indexOf(weekdays, '四') != -1
            totalCount += 1 if _.indexOf(weekdays, '五') != -1
            totalCount += 1 if _.indexOf(weekdays, '六') != -1
            totalCount += 1 if _.indexOf(weekdays, '日') != -1

            if totalCount == 7
                return '時間不拘'
            else if totalCount > 3
                weekdays.splice(1, totalCount - 3)
                new_weekdays = []
                new_weekdays.push weekdays[0]
                new_weekdays.push '...'
                #new_weekdays.push weekdays[weekdays.length - 2]
                new_weekdays.push weekdays[weekdays.length - 1]
                return _.join(new_weekdays, ', ')
            else
                return _.join(weekdays, ', ')

        $scope.parseLocation = (locations) ->
            locations = locations.split(',')
            if locations.length == 0
                locations = constants.LOCATIONS
            totalCount = 0
            totalCount += 1 if _.indexOf(locations, '建國') != -1
            totalCount += 1 if _.indexOf(locations, '忠孝') != -1
            totalCount += 1 if _.indexOf(locations, '延平') != -1
            totalCount += 1 if _.indexOf(locations, '大安') != -1
            totalCount += 1 if _.indexOf(locations, '台中') != -1
            totalCount += 1 if _.indexOf(locations, '高雄') != -1

            if totalCount == 6
                return '地點不拘'
            else if totalCount > 2
                new_locations = []
                new_locations.push locations[0]
                #new_locations.push locations[1]
                new_locations.push '...'
                return _.join(new_locations, ', ')
            else
                return _.join(locations, ', ')

        $ionicModal.fromTemplateUrl('templates/modal-weekday.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalWeekday = modal
        )

        $ionicModal.fromTemplateUrl('templates/modal-location.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalLocation = modal
        )
]