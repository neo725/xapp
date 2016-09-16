module.exports = [
    '$rootScope', '$scope', '$stateParams', '$log', '$timeout', '$interpolate', '$translate', '$ionicHistory', 'plugins', 'navigation', 'modal', 'api'
    ($rootScope, $scope, $stateParams, $log, $timeout, $interpolate, $translate, $ionicHistory, plugins, navigation, modal, api) ->
        loadTimes = 0
        $scope.noMoreItemsAvailable = false
        $scope.keyword = $stateParams.keyword

        backView = $ionicHistory.backView()
        stateName = null

        if backView
            stateName = backView.stateName

        if stateName == 'home.dashboard'
            $scope.noMoreItemsAvailable = false

            $translate(['title.search_course', 'input.input_keyword']).then (translation) ->
                $scope.pageTitle = translation['title.search_course']
                $scope.placeholderKeyword = translation['input.input_keyword']

        if stateName == 'home.course.catalogs'
            $scope.noMoreItemsAvailable = true

            catalog = $rootScope.catalog
            params =
                catalog_name: catalog.catalog_name
                catalog_id: catalog.catalog_id
            $translate(['title.search_course_in_catalogs', 'input.input_keyword_in_catalogs'], params).then (translation) ->
                $scope.pageTitle = translation['title.search_course_in_catalogs']
                $scope.placeholderKeyword = translation['input.input_keyword_in_catalogs']

        $scope.goBack = () ->
            if backView
                navigation.slide backView.stateName, {}, 'right'
            else
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
                modal.showMessage '', 'errors.request_failed'

            backView = $ionicHistory.backView()
            data = {}

            if not backView
                navigation.slide 'home.dashboard', {}, 'right'

            if backView.stateName == 'home.dashboard'
                weekdays = _.join(JSON.parse(window.localStorage.getItem('weekdays'), ','))
                locations = _.join(JSON.parse(window.localStorage.getItem('locations'), ','))

                data =
                    'perpage': 20
                    'query': keyword
                    'wday': weekdays
                    'loc': locations

            if backView.stateName == 'home.course.catalogs'
                catalog = $rootScope.catalog
                data =
                    'perpage': 20
                    'query': keyword
                    'cate': catalog.catalog_id

            modal.showLoading '', 'message.searching'
            api.searchCourse(data, onSuccess, onError)

        if $stateParams.keyword
            $scope.goSearch($stateParams.keyword)

        $scope.$on('$ionicView.enter', ->
            $log.info '$ionicView.enter'
            #data = window.localStorage.getItem('favorite_changed')

            #if data
                #data = JSON.parse(data)
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