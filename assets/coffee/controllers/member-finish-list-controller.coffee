module.exports = [
    '$scope', 'navigation', 'modal', 'api'
    ($scope, navigation, modal, api) ->
        $scope.loading = false

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

        loadSurveyList = (course_list) ->
            onSuccess = (response) ->
                list = response.list
                i = 0
                while i < course_list.length
                    prod_id = course_list[i].Prod_Id
                    ques_index = _(list).findIndex({ 'classId': prod_id })
                    if ques_index == -1
                        continue
                    if list[ques_index].quesList == undefined or list[ques_index].quesList.length == 0
                        continue
                    ques = list[ques_index].quesList[0]
                    topics = ques.topics
                    course_list[i].ques_topics = topics
                    i++

                $scope.courses = course_list

                modal.hideLoading()
            onError = () ->
                modal.hideLoading()

            api.getSurveys(onSuccess, onError)

        loadCourseList = (success_fn) ->
            $scope.loading = true

            modal.showLoading('', 'message.data_loading')
            onSuccess = (response) ->
                list = response.list

                ((success_fn) || (->))(list)
            onError = () ->
                modal.hideLoading()

            api.getFinishCourses(1, 500, onSuccess, onError)

            $scope.loading = false


        loadCourseList(loadSurveyList)

]