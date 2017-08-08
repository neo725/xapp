module.exports = [
    '$scope', '$log', 'navigation', 'modal', 'api'
    ($scope, $log, navigation, modal, api) ->
        $scope.loading = true

        $scope.courses = []

        $scope.radius = 35
        $scope.stroke = 1
        $scope.radius_multiple = 1.65
        $scope.stroke_multiple = 1.1
        $scope.offset = 8

        $scope.rating = [5, 5, 5, 5]


        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.goExtend = (prod_id) ->
            navigation.slide 'home.course.extend', { 'course_id': prod_id }, 'left'

        $scope.proccessTopics = (topics) ->
            data =
                is_multi_teacher: false
                satisfied:
                    count: 0
                    items: []
                unsatisfied:
                    count: 0
                    items: []
            _.forEach(topics, (topic) ->
                satisfied = false
                unsatisfied = false
                _.forEach(topic.answerList, (answer) ->
                    if answer.event_value == '不滿意'
                        unsatisfied = true
                    else if answer.event_value == '滿意'
                        satisfied = true
                )
                if satisfied == true
                    data.satisfied.count += 1
                    data.satisfied.items.push topic.topic_subname
                else if unsatisfied == true
                    data.unsatisfied.count += 1
                    data.unsatisfied.items.push topic.topic_subname

                if topic.topic_subname
                    title = switch
                        when topic.topic_subname == '內容' then 'content'
                        when topic.topic_subname == '服務' then 'service'
                        when topic.topic_subname == '師資' then 'teacher'
                        when topic.topic_subname == '環境' then 'environment'
                        else 'unknown'
                    data["item_#{title}"] = satisfied

                    if topic.topic_Correlation == 'teacher' and topic.teacher_id
                        data.is_multi_teacher = true

                        if not data['teachers']
                            data.teachers = []

                        index = _.findIndex(data.teachers, { teacher_id: topic.teacher_id })
                        if index == -1
                            teacher = {
                                teacher_id: topic.teacher_id
                                teacher_name: topic.teacher_name
                            }
                            teacher["item_#{title}"] = satisfied
                            data.teachers.push teacher
                        else
                            data.teachers[index]["item_#{title}"] = satisfied
                    return
            )

            $log.info data

            return data

        loadSurveyList = (course_list) ->
            onSuccess = (response) ->
                list = response.list
                i = 0
                while i < course_list.length
                    prod_id = course_list[i].Prod_Id
                    class_index = _.findIndex(list, { 'classId': prod_id })
                    if class_index == -1
                        continue
                    if list[class_index].quesList == undefined or list[class_index].quesList.length == 0
                        continue
                    ques = list[class_index].quesList[0]
                    topics = ques.topics
                    course_list[i].ques_topics = topics
                    i++

                $scope.courses = course_list

                modal.hideLoading()
                $scope.loading = false
            onError = () ->
                modal.hideLoading()
                $scope.loading = false

            api.getSurveys(onSuccess, onError)

        loadCourseList = (success_fn) ->
            onSuccess = (response) ->
                list = response.list

                ((success_fn) || (->))(list)
            onError = () ->
                modal.hideLoading()

            api.getFinishCourses(1, 500, onSuccess, onError)

        modal.showLoading('', 'message.data_loading')
        loadCourseList(loadSurveyList)

]
