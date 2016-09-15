module.exports = [
    '$scope', 'navigation', 'api', ($scope, navigation, api) ->
        $scope.courses = []

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        loadCourse = ->
            onSuccess = (response) ->
                $scope.courses = response.list

                $.each($scope.courses, (index, item) ->
                    # year
                    item.year = moment(item.Prod_ClsOpenDate,"YYYY-MM-DD").year()
                    # date
                    item.date = moment(item.Prod_ClsOpenDate,"YYYY-MM-DD").format("MM.DD")
                    # weekday
                    item.weekday = moment(item.Prod_ClsOpenDate,"YYYY-MM-DD").locale("zh-TW").format("dd")
                    # keep
                    item.keep_image_name = 'heart@2x.png'
                )
            onError = (->)

            api.getWishList(1, 500, onSuccess, onError)

        loadCourse()
]