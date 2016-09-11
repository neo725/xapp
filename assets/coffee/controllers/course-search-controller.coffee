module.exports = [
    '$scope', '$stateParams', '$log', '$timeout', '$translate', 'plugins', 'navigation', 'modal', 'api'
    ($scope, $stateParams, $log, $timeout, $translate, plugins, navigation, modal, api) ->
        loadTimes = 0
        $scope.noMoreItemsAvailable = false

        $scope.keyword = $stateParams.keyword


        $scope.goBack = () ->
            navigation.slide 'home.dashboard', {}, 'right'

        $scope.keywordFocus = () ->

        $scope.switchToCourseInfo = (shop_id, prod_id) ->
            navigation.slide 'home.course.info', {shop_id: shop_id, prod_id: prod_id}, 'left'

        $scope.loadMore = () ->
            #plugins.toast.show('load more', 'long', 'top')
            loadTimes += 1
            if loadTimes == 3
                $scope.noMoreItemsAvailable = true;
            $timeout () ->
                $scope.$broadcast('scroll.infiniteScrollComplete')
            , 3000

        $scope.addOrRemoveFromWish = (course, $event) ->
            $event.stopPropagation()

            onSuccess = () ->
                if course.isFavorite == 0
                    course.keep_image_name = 'heart@2x.png'
                    course.isFavorite = 1
                    $translate('message.favorite_added').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                else
                    course.keep_image_name = 'heart-outline@2x.png'
                    course.isFavorite = 0
                    $translate('message.favorite_removed').then (text) ->
                        plugins.toast.show(text, 'long', 'top')

            onError = (error) ->
                $log.info error

            if course.isFavorite == 0
                api.addToWish course.Shop_Id, course.Prod_Id, onSuccess, onError
            else
                api.removeFromWish course.Shop_Id, course.Prod_Id, onSuccess, onError

        $scope.goSearch = (keyword) ->
            $scope.courses = []

            hideLoading = () ->
                modal.hideLoading()

            onSuccess = (response) ->
                hideLoading()
                $scope.courses = response.resultList.list
                $.each($scope.courses, (index, item) ->
                    # year
                    item.year = moment(item.Prod_ClsOpenDate,"YYYY-MM-DD").year()
                    # date
                    item.date = moment(item.Prod_ClsOpenDate,"YYYY-MM-DD").format("MM.DD")
                    # weekday
                    item.weekday = moment(item.Prod_ClsOpenDate,"YYYY-MM-DD").locale("zh-TW").format("dd")
                    # keep
                    if item.isFavorite == 1
                        item.keep_image_name = 'heart@2x.png'
                    else
                        item.keep_image_name = 'heart-outline@2x.png'
                )

            onError = () ->
                hideLoading()
                modal.showMessage '', 'message.error'

            weekdays = _.join(JSON.parse(window.localStorage.getItem('weekdays'), ','))
            locations = _.join(JSON.parse(window.localStorage.getItem('locations'), ','))

            data =
                'perpage': 20
                'query': keyword
                'wday': weekdays
                'loc': locations

            modal.showLoading '', 'message.searching'
            api.searchCourse(data, onSuccess, onError)

        $scope.goSearch($stateParams.keyword)

        $scope.$on('$ionicView.enter', ->
            $log.info '$ionicView.enter'
            data = window.localStorage.getItem('favorite_changed')
            if data
                data = JSON.parse(data)

                $.each($scope.courses, (index, item) ->
                    if item.Prod_Id == data.prod_id
                        item.isFavorite = data.is_favorite
                        if item.isFavorite == 1
                            item.keep_image_name = 'heart@2x.png'
                        else
                            item.keep_image_name = 'heart-outline@2x.png'
                )
                window.localStorage.removeItem('favorite_changed')
        )
]