constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicModal', '$ionicSlideBoxDelegate', '$timeout', '$log', 'api', 'modal', 'user', 'CacheFactory',
    'navigation',
    ($rootScope, $scope, $ionicModal, $ionicSlideBoxDelegate, $timeout, $log, api, modal, user, CacheFactory,
        navigation) ->
            # angular svg round progressbar
            # repo : https://github.com/crisbeto/angular-svg-round-progressbar
            # demo : http://crisbeto.github.io/angular-svg-round-progressbar/
            $scope.current = 50
            $scope.radius = 43
            $scope.stroke = 4
            $scope.clockwise = false
            $rootScope.studyCardVisible = false

            waitToDeleteStudyCards = []

    #        if not CacheFactory.get('studycardCache')
    #            opts =
    #                storageMode: 'sessionStorage'
    #            CacheFactory.createCache('studycardCache', opts)
    #        studycardCache = CacheFactory.get('studycardCache')
            if not CacheFactory.get('surveyCache')
                opts =
                    storageMode: 'sessionStorage'
                CacheFactory.createCache('surveyCache', opts)
            surveyCache = CacheFactory.get('surveyCache')


            $scope.getDatePart = (date) ->
                return moment(date).format('YYYY/M/DD')

            $scope.getShortDatePart = (date) ->
                return moment(date).format('M/DD')

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
                course = {
                    Prod_Id: card.Prod_Id,
                    Prod_Name: card.Prod_Name
                }
                surveyCache.put 'current', course
                navigation.slide 'home.course.survey', {}, 'left'
                return
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
                if user.getIsGuest()
                    return

                $log.info '[** StudycardSlide **] >> loadStudycard()......'

    #            studycards_in_cache = studycardCache.get('all')

                load = (list) ->
                    $rootScope.studyCards = list
                    $rootScope.studyCardVisible = list.length > 0

                    $timeout(->
                        $ionicSlideBoxDelegate.update()
                    , 500)

                onSuccess = (response) ->
                    load response.list
    #                studycardCache.put 'all', response.list
                    modal.hideLoading()

                onError = () ->
                    $rootScope.studyCardVisible = false
                    modal.hideLoading()

    #            if studycards_in_cache
    #                load studycards_in_cache
    #            else
    #                modal.showLoading '', 'message.loading_cover'
    #                api.getStudyCards(onSuccess, onError)
                modal.showLoading '', 'message.loading_cover'
                api.getStudyCards(onSuccess, onError)

            $scope.$on('dashboard-controller.enter', () ->
                $log.info '[** StudycardSlide **] >> dashboard-controller.enter  ......'

                $ionicSlideBoxDelegate.update()

                if waitToDeleteStudyCards.length > 0
                    _.forEach(waitToDeleteStudyCards, (prod_id) ->
                        index = _($rootScope.studyCards).findIndex({ 'Prod_Id': prod_id })
                        if index > -1
                            $rootScope.studyCards.splice(index, 1)

                        $rootScope.studyCardVisible = ($rootScope.studyCards.length > 0)

                        if $rootScope.studyCards.length > 0 and index > -1
                            newIndex = index - 1
                            if newIndex == -1
                                newIndex = 0
                            $ionicSlideBoxDelegate.$getByHandle('studycard-slide-box').slide(newIndex)
                        $ionicSlideBoxDelegate.update()
                    )
                    waitToDeleteStudyCards = []
            )
            $scope.$on('index-controller.onNotificationRegistered', () ->
                $log.info '{** StudycardSlide **} >> index-controller.onNotificationRegistered......'
            )
            $scope.$on('dashboard.doRefresh', () ->
                $log.info '{** StudycardSlide **} >> doRefresh......'
                loadStudycard()
            )

            loadStudycard()

            deleteStudyCards = (prod_id) ->
                waitToDeleteStudyCards.push prod_id
                $log.info '[** StudycardSlide **] deleteStudyCards : ' + prod_id

            $rootScope.deleteStudyCards = deleteStudyCards

            $scope.$on('$ionicView.enter', ->
            )
            $scope.$on('dashboard-controller.afterEnter', ->
                $ionicSlideBoxDelegate.update()
            )
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