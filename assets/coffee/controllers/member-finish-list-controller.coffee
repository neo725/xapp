module.exports = [
    '$scope', 'navigation', 'modal', 'api'
    ($scope, navigation, modal, api) ->
        $scope.radius = 35
        $scope.stroke = 1


        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        loadSurveyList = (course_list) ->
            onSuccess = (response) ->
                modal.hideLoading()
            onError = ->
                modal.hideLoading()

            api.getSurveys(onSuccess, onError)

        loadCourseList = (success_fn) ->
            onSuccess = (response) ->
                list = response.list

                console.log list
                ((success_fn) || (->))(list)
            onError = ->
                modal.hideLoading()

            api.getFinishCourses(1, 500, onSuccess, onError)

        loadCourseList(loadSurveyList)

]