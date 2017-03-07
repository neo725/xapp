module.exports = [
    '$rootScope', '$scope', '$stateParams', '$ionicHistory', 'api', 'navigation', 'modal', 'CacheFactory',
    ($rootScope, $scope, $stateParams, $ionicHistory, api, navigation, modal, CacheFactory) ->
        $scope.originTopics = []
        $scope.data = {}

        shop_id = $stateParams.shop_id
        prod_id = $stateParams.prod_id

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

        $scope.changeSubTopicEvent = (topic, item) ->
            console.log $scope.originTopics

        rearrangeTopics = (topics) ->
            new_topics = []
            _.forEach(topics, (topic) ->
                if not topic.before_topic
                    new_topics.push topic
            )
            return new_topics

        loadSurveyTopics = (course_id) ->
            onSuccess = (response) ->
                console.log response
                $scope.topics = rearrangeTopics(response.topics)
                $scope.originTopics = response.topics
            onError = (->)

            api.getSurveyFillByCourse course_id, onSuccess, onError


        course_in_cache = surveyCache.get 'current'
        $scope.course = course_in_cache

        loadSurveyTopics $scope.course.Prod_Id
]