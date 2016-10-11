module.exports = [
    '$scope', '$log', '$translate', 'navigation', 'api', ($scope, $log, $translate, navigation, api) ->
        $scope.courses = []

        $scope.goBack = ->
            navigation.slide 'home.member.dashboard', {}, 'right'

        $scope.removeFromWish = (course, $event) ->
            $event.stopPropagation()
            onSuccess = () ->
                _.remove($scope.courses, {Prod_Id: course.Prod_Id})

                $translate('message.favorite_removed').then (text) ->
                    plugins.toast.show(text, 'long', 'top')

            onError = (error) ->
                $log.info error

            api.removeFromWish course.Shop_Id, course.Prod_Id, onSuccess, onError

        $scope.switchToCourseInfo = (shop_id, prod_id) ->
            navigation.slide 'home.course.info', {shop_id: shop_id, prod_id: prod_id}, 'left'

        loadFavoriteCourses = ->
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

        loadFavoriteCourses()
]