module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$stateParams', 'navigation', 'modal', 'api',
    ($rootScope, $scope, $ionicHistory, $stateParams, navigation, modal, api) ->
        $scope.noMoreItemsAvailable = false
        $scope.page = 1
        $scope.pageSize = 20
        $scope.loadingSearch = false
        $scope.order = 'start'

        prod_id = $stateParams.course_id

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide backView.stateName, {}, 'right'
            else
                navigation.slide 'home.dashboard', {}, 'right'

        $scope.loadMore = () ->
            if not $scope.noMoreItemsAvailable and $scope.page > 1
                goSearch($scope.page, $scope.pageSize, $scope.keyword)

        $scope.switchToCourseInfo = (shop_id, prod_id) ->
            navigation.slide 'home.course.info', {shop_id: shop_id, prod_id: prod_id}, 'left'

        goSearch = (page, pagesize, prod_id) ->

            $scope.loadingSearch = true

            if page == 1
                $scope.courses = []

            onSuccess = (response) ->
                modal.hideLoading()

                list = response.list
                pagerInfo = response.pagerInfo

                if page == 1
                    $scope.courses = list
                else
                    i = 0
                    max = list.length
                    while i < max
                        $scope.courses.push list[i]
                        i++

                is_last_page = (pagerInfo.now_page * pagerInfo.per_page) > pagerInfo.total_rec
                $scope.noMoreItemsAvailable = is_last_page

                if not is_last_page
                    $scope.page = $scope.page + 1

                $scope.$broadcast('scroll.infiniteScrollComplete')

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
                modal.hideLoading()

            data =
                'page': page
                'perpage': pagesize
                'order': $scope.order

            modal.showLoading '', 'message.searching'
            api.loadCourseExtend(prod_id, data, onSuccess, onError)

        goSearch($scope.page, $scope.pageSize, prod_id)

        $scope.$on('$ionicView.enter', ->
            if $rootScope.favorite_changed
                data = $rootScope.favorite_changed

                $.each($scope.courses, (index, item) ->
                    if item.Prod_Id == data.prod_id
                        item.isFavorite = data.is_favorite
                        if item.isFavorite == 1
                            item.keep_image_name = 'heart@2x.png'
                        else
                            item.keep_image_name = 'heart-outline@2x.png'
                )
                #window.localStorage.removeItem('favorite_changed')
                delete $rootScope['favorite_changed']
        )
]