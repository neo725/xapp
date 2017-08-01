module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$log', '$translate', 'api', 'plugins', 'navigation', 'modal', 'CacheFactory',
    ($rootScope, $scope, $ionicHistory, $log, $translate, api, plugins, navigation, modal, CacheFactory) ->
        #$scope.originTopics = []
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

        $scope.changeTopicEvent = (topic, item, teacher) ->
            topic.sub_topics = []
            if item.After_Topic
                after_topic = item.After_Topic
                after_topics = after_topic.split(',')
                _.forEach(after_topics, (topic_no) ->
                    findData =
                        Topic_No: topic_no
                    if teacher
                        findData.sir_id = teacher.sir_id

                    findItem = _.find($scope.topics_map, findData)

                    if findItem
                        topic.sub_topics.push(findItem)
                )

        $scope.testIsAllAlphaBetsOnly = (text) ->
            regex = /^[a-zA-Z0-9 \(\)\.]*/g

            match = regex.exec text
            if match
                return match.length == 1 and match[0] == match.input

            return false

        $scope.filterTeacher = (topics, teacher, teachers) ->
            if teachers.length < 2
                return topics

            filtered_topics = []
            _.forEach(topics, (topic) ->
                if not teacher
                    if not topic.sir_id
                        filtered_topics.push topic
                else
                    if topic.sir_id == teacher.sir_id
                        filtered_topics.push topic
            )
            return filtered_topics

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
            max = $scope.topics_map.length
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
                topic = $scope.topics_map[i]
                data =
                    'topic_no': topic.Topic_No
                    'answer_value': findEventNo(topic.events, topic.event_value).toString()
                if topic.Topic_Correlation == 'teacher'
                    data.teacher_id = topic.sir_id
                topics.push(data)
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

        makeTopicsMap = (topics, teachers) ->
            root_topics = findRootTopics(topics)
            topics_map = []
            _.forEach(topics, (topic) ->
                topic.index = _.findIndex(root_topics, { Topic_No: topic.Topic_No })
                if teachers.length == 0
                    topics_map.push topic
                else
                    if topic.Topic_Correlation != 'teacher'
                        topics_map.push topic
                    else
                        _.forEach(teachers, (teacher) ->
                            topic_copy = angular.copy(topic)
                            topic_copy.sir_id = teacher.sir_id
                            topics_map.push(topic_copy)
                        )
            )
            $log.info topics_map
            return topics_map

        loadSurveyTopics = (course_id) ->
            onSuccess = (response) ->
                modal.hideLoading()

                $scope.ques_no = response.Quest_No
                $scope.teachers = response.teachers
                $scope.topics_map = makeTopicsMap(response.topics, response.teachers)
                $scope.topics = findRootTopics($scope.topics_map)
                $scope.topic_loaded = true
            onError = () ->
                modal.hideLoading()

            modal.showLoading '', 'message.data_loading'
            api.getSurveyFillByCourse course_id, onSuccess, onError

        course_in_cache = surveyCache.get 'current'
        $scope.course = course_in_cache

        loadSurveyTopics $scope.course.Prod_Id
]
