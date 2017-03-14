module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$timeout', '$translate', 'api', 'plugins', 'navigation', 'modal', 'CacheFactory',
    ($rootScope, $scope, $ionicHistory, $timeout, $translate, api, plugins, navigation, modal, CacheFactory) ->
        $scope.originTopics = []
        $scope.topic_loaded = false

        if not CacheFactory.get('surveyCache')
            opts =
                storageMode: 'sessionStorage'
            CacheFactory.createCache('surveyCache', opts)
        surveyCache = CacheFactory.get('surveyCache')

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.changeTopicEvent = (topic, item) ->
            topic.sub_topics = []
            if item.After_Topic
                after_topic = item.After_Topic
                after_topics = after_topic.split(',')
                _.forEach(after_topics, (topic_no) ->
                    findItem = _.find($scope.originTopics, { Topic_No: topic_no })
                    topic.sub_topics.push(findItem)
                )

        $scope.submitForm = (form) ->
            if not form.$valid
                $translate(['title.survey', 'errors.form_validate_error', 'popup.ok']).then (translator) ->
                    plugins.notification.alert(
                        translator['errors.form_validate_error'],
                        (->),
                        translator['title.survey'],
                        translator['popup.ok']
                    )
                return

            topics = []
            i = 0
            max = $scope.originTopics.length
            findEventNo = (events, value) ->
                find = (events, value) ->
                    index = _.findIndex(events, { Event_Value: value })
                    if index == -1
                        return index
                    return events[index].Event_No

                if not value
                    return ''

                if value.indexOf(',') == -1
                    return find(events, value)
                else
                    values = value.split(',')
                    event_nos = []
                    _.forEach(values, (value) ->
                        event_no = find(events, value)
                        event_nos.push event_no
                    )
                    return event_nos.join(',')

            while i < max
                topic = $scope.originTopics[i]
                topics.push
                    'topic_no': topic.Topic_No
                    'answer_value': findEventNo(topic.events, topic.event_value).toString()
                i++
            data = {
                'class_id': $scope.course.Prod_Id
                'answers': topics
            }

            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.deleteStudyCards $scope.course.Prod_Id

                callGoBack = ->
                    $scope.goBack()

                if response and response.popout
                    $translate(['popup.ok']).then (translator) ->
                        plugins.notification.confirm(
                            response.popout,
                            callGoBack,
                            '',
                            [translator['popup.ok']]
                        )

            onError = () ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_loading')
            api.postSurveyFill(data, onSuccess, onError)

        findRootTopics = (topics) ->
            new_topics = []
            _.forEach(topics, (topic) ->
                if not topic.before_topic
                    new_topics.push topic
            )
            return new_topics

        loadSurveyTopics = (course_id) ->
            onSuccess = (response) ->
                modal.hideLoading()

                $scope.topics = findRootTopics(response.topics)
                $scope.originTopics = response.topics
                $scope.topic_loaded = true
            onError = () ->
                modal.hideLoading()

            modal.showLoading '', 'message.data_loading'
            api.getSurveyFillByCourse course_id, onSuccess, onError

        course_in_cache = surveyCache.get 'current'
        $scope.course = course_in_cache

        loadSurveyTopics $scope.course.Prod_Id
]