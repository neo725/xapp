constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$ionicSlideBoxDelegate', '$log', 'api', 'modal', 'user',
    ($rootScope, $scope, $ionicModal, $ionicSlideBoxDelegate, $log, api, modal, user) ->
        # angular svg round progressbar
        # repo : https://github.com/crisbeto/angular-svg-round-progressbar
        # demo : http://crisbeto.github.io/angular-svg-round-progressbar/
        $scope.current = 50
        $scope.radius = 43
        $scope.stroke = 4
        $scope.clockwise = false
        $rootScope.studyCardVisible = false

        $scope.getDatePart = (date) ->
            return moment(date).format('YYYY/M/DD')

        $scope.getTimePart = (date) ->
            return moment(date).format('H:mm')

        $scope.getWeekdayName = (date) ->
            return constants.WEEKDAYS[moment(date).isoWeekday() - 1]

        $scope.getPercentage = (value) ->
            value *= 100
            return Math.floor(value)

        $scope.getLocationFullName = (value) ->
            item = _.find(constants.LOCATIONS_MAPPING, { short_name: value })
            if item
                return item['full_name']
            return value

        $scope.openFeedback = (card) ->
            modal.showLoading('', 'message.data_loading')

            $rootScope.currentCard = card

            onSuccess = (response) ->
                if ($rootScope.resetStarFunction)
                    $rootScope.resetStarFunction()
                topics = _.orderBy(response.topics, ['Topic_Sort'], ['asc'])
                $rootScope.topics = topics
                modal.hideLoading()
                $scope.modalFeedback.show()
            onError = () ->
                modal.hideLoading()

            api.getSurveyFill(onSuccess, onError)

        $scope.openCourseTime = (card) ->
            $rootScope.currentCard = card
            $scope.modalCourseTime.show()

        $scope.openCourseLocation = (card) ->
            $rootScope.currentCard = card
            $scope.modalCourseLocation.show()

        loadStudycard = () ->
            $log.info '[** StudycardSlide **] >> loadStudycard()......'

            onSuccess = (response) ->
                list = response.list

                $rootScope.studyCards = list
                $rootScope.studyCardVisible = list.length > 0

                $ionicSlideBoxDelegate.update()
                $rootScope.loadStudycardSlide = false

            onError = () ->
                $rootScope.studyCardVisible = false

            api.getStudyCards(onSuccess, onError)

        $scope.$on('dashboard-controller.enter', () ->
            $log.info '[** StudycardSlide **] >> dashboard-controller.enter  ......'

            $log.info '[** StudycardSlide **] >> $rootScope.fromNotification : ' + $rootScope.fromNotification
            $log.info '[** StudycardSlide **] >> $rootScope.loadStudycardSlide : ' + $rootScope.loadStudycardSlide
            if $rootScope.fromNotification
                if user.isGuest()
                    $rootScope.fromNotification = not $rootScope.loadSearchSlide
                else
                    $rootScope.fromNotification = not ($rootScope.loadStudycardSlide and $rootScope.loadSearchSlide)

                #$rootScope.loadStydycardSlide = true
                $ionicSlideBoxDelegate.update()

#            if $rootScope.loadStudycardSlide
#                loadStudycard()
        )
        $scope.$on('index-controller.onNotificationRegistered', () ->
            $log.info '{** StudycardSlide **} >> index-controller.onNotificationRegistered......'
#            $log.info '[** StudycardSlide **] >> $rootScope.fromNotification : ' + $rootScope.fromNotification
#            $log.info '[** StudycardSlide **] >> $rootScope.loadStudycardSlide : ' + $rootScope.loadStudycardSlide
#            $log.info '[** StudycardSlide **] >> $rootScope.loadSearchSlide : ' + $rootScope.loadSearchSlide
#            $log.info '[** StudycardSlide **] >> isGuest : ' + user.isGuest()
#            $log.info '[** StudycardSlide **] >> isRealDevice : ' + user.isRealDevice()
            if not user.isGuest()
                loadStudycard()
        )
#        $log.info '[** StudycardSlide **] >> loadStudycard()'
#        $log.info '[** StudycardSlide **] >> $rootScope.fromNotification : ' + $rootScope.fromNotification
#        $log.info '[** StudycardSlide **] >> $rootScope.loadStudycardSlide : ' + $rootScope.loadStudycardSlide
#        $log.info '[** StudycardSlide **] >> $rootScope.loadSearchSlide : ' + $rootScope.loadSearchSlide
#        $log.info '[** StudycardSlide **] >> isGuest : ' + user.isGuest()
#        $log.info '[** StudycardSlide **] >> isRealDevice : ' + user.isRealDevice()

#        if not user.isGuest() and not user.isRealDevice()
#            loadStudycard()
        loadStudycard()

        $ionicModal.fromTemplateUrl('templates/modal-feedback.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalFeedback = modal
        )

        $ionicModal.fromTemplateUrl('templates/modal-course-time.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalCourseTime = modal
        )

        $ionicModal.fromTemplateUrl('templates/modal-course-location.html',
            scope: $scope
            animation: 'fade-in'
        ).then((modal) ->
            $scope.modalCourseLocation = modal
        )
]