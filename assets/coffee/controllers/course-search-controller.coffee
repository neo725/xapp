module.exports = [
    '$rootScope', '$scope', '$stateParams', '$log', '$timeout', '$interpolate', '$translate', '$ionicHistory', '$ionicPopover',
    'plugins', 'navigation', 'modal', 'api'
    ($rootScope, $scope, $stateParams, $log, $timeout, $interpolate, $translate, $ionicHistory, $ionicPopover,
        plugins, navigation, modal, api) ->

        $scope.option_visible = false
        $scope.order = 'start'

        $scope.filter = {}
        $scope.filter.location = []
        $scope.filter.weekdays = ['一', '二', '三', '四', '五', '六', '日']
        $scope.filter.weekday = []

        $scope.noMoreItemsAvailable = false
        $scope.page = 1
        $scope.pageSize = 20
        $scope.keyword = $stateParams.keyword
        $scope.loadingSearch = false

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
            if not $scope.noMoreItemsAvailable and $scope.page > 1
                #console.log 'loadMore - ' + $scope.page
                goSearch($scope.page, $scope.pageSize, $scope.keyword)

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

        $scope.showOptions = ($event) ->
            $scope.popover.show($event)

        $scope.showHistory = ($event) ->
            $scope.popoverHistory.show($event)

        $scope.hideHistory = ->
            $scope.popoverHistory.hide()

        $scope.setOrder = (value) ->
            $scope.order = value
            $scope.goSearch($stateParams.keyword)
            $timeout(->
                $scope.popover.hide()
            )

        $scope.show_order_tab = () ->
            $timeout(->
                $('.popover-condition').removeClass('large')
            )

        $scope.show_filter_tab = () ->
            $timeout(->
                $('.popover-condition').addClass('large')

                $('#price-range').ionRangeSlider(
                    min: 0
                    max: 50000
                    from: 0
                    to: 50000
                    type: 'double'
                    prefix: "$"
                    grid: false
                    grid_num: 10
                    step: 1000
                )
            )

        $scope.toggleLocation = (value) ->
            index = _.indexOf($scope.filter.location, value)
            if index == -1
                $scope.filter.location.push value
            else
                $scope.filter.location.splice index, 1

        $scope.checkLocation = (value) ->
            index = _.indexOf($scope.filter.location, value)
            if index == -1
                return false
            return true

        $scope.toggleWeekday = (value) ->
            index = _.indexOf($scope.filter.weekday, value)
            if index == -1
                $scope.filter.weekday.push value
            else
                $scope.filter.weekday.splice index, 1

        $scope.checkWeekday = (value) ->
            index = _.indexOf($scope.filter.weekday, value)
            if index == -1
                return false
            return true

        $scope.cancelPopover = ->
            $scope.popover.hide()

        $scope.submitPopover = ->
            price_range = $('#price-range').data('ionRangeSlider')
            if price_range.result.from == price_range.result.min
                delete $scope.filter['lmoney']
            else
                $scope.filter.lmoney = price_range.result.from
            if price_range.result.to == price_range.result.max
                delete $scope.filter['umoney']
            else
                $scope.filter.umoney = price_range.result.to

            # location
            pushItem = (array, value) ->
                if _.indexOf(array, value) == -1
                    array.push(value)
                array

            if _.indexOf($scope.filter.location, '台北') != -1
                $scope.filter.location = pushItem($scope.filter.location, '建國')
                $scope.filter.location = pushItem($scope.filter.location, '忠孝')
                $scope.filter.location = pushItem($scope.filter.location, '延平')
                $scope.filter.location = pushItem($scope.filter.location, '大安')
            else
                $scope.filter.location = popItem($scope.filter.location, '建國')
                $scope.filter.location = popItem($scope.filter.location, '忠孝')
                $scope.filter.location = popItem($scope.filter.location, '延平')
                $scope.filter.location = popItem($scope.filter.location, '大安')

            $scope.goSearch($stateParams.keyword)

            $scope.popover.hide()

        $scope.arrangeLocation = (loc) ->
            if loc is null
                return ''

            location = loc.split(',')

            location_taipei = true
            location_taipei &= _.indexOf(location, '建國') != -1
            location_taipei &= _.indexOf(location, '忠孝') != -1
            location_taipei &= _.indexOf(location, '延平') != -1
            location_taipei &= _.indexOf(location, '大安') != -1

            if location_taipei
                location = popItem(location, '建國')
                location = popItem(location, '忠孝')
                location = popItem(location, '延平')
                location = popItem(location, '大安')
                if _.indexOf(location, '台北') == -1
                    location.splice(0, 0, '台北')

            index = _.indexOf(location, '台北')
            if index != -1 and index != 0
                location = popItem(location, '台北')
                location.splice(0, 0, '台北')

            return location.join(',')

        $scope.arrangeWeekday = (wday) ->
            if wday is null
                return ''

            weekdays = wday.split(',')

            weekday_all = true
            weekday_all &= _.indexOf(weekdays, '一') != -1
            weekday_all &= _.indexOf(weekdays, '二') != -1
            weekday_all &= _.indexOf(weekdays, '三') != -1
            weekday_all &= _.indexOf(weekdays, '四') != -1
            weekday_all &= _.indexOf(weekdays, '五') != -1
            weekday_all &= _.indexOf(weekdays, '六') != -1
            weekday_all &= _.indexOf(weekdays, '日') != -1

            if weekday_all
                return '時間不拘'

            return weekdays.join(',')

        popItem = (array, value) ->
            index = _.indexOf(array, value)
            if index != -1
                array.splice(index, 1)
            array

        loadHistory = (success) ->
            onSuccess = (response) ->
                modal.hideLoading()
                max_splice_length = 5
                list = response.historyList.list
                if Array.isArray(list)
                    if max_splice_length > list.length
                        max_splice_length = list.length
                    $scope.historyList = list.splice(0, max_splice_length)
            onError = () ->
                modal.hideLoading()

            modal.showLoading '', 'message.data_loading'
            api.searchCourse({ 'page': 1, 'perpage': 20 }, onSuccess, onError)

        goSearch = (page, pagesize, keyword) ->
            #console.log 'goSearch - ' + page
            $scope.loadingSearch = true

            if page == 1
                $scope.courses = []

            onSuccess = (response) ->
                modal.hideLoading()

                list = response.resultList.list
                pagerInfo = response.resultList.pagerInfo

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
                modal.showMessage '', 'errors.request_failed'

            backView = $ionicHistory.backView()
            data = {}

            if backView is null or backView == undefined or backView.stateName == undefined
                navigation.slide 'home.dashboard', {}, 'right'
                return

            if backView.stateName == 'home.dashboard'
                #weekdays = _.join(JSON.parse(window.localStorage.getItem('weekdays'), ','))
                #locations = _.join(JSON.parse(window.localStorage.getItem('locations'), ','))

                data =
                    'page': page
                    'perpage': pagesize
                    'query': keyword
                    'wday': _.join($scope.filter.weekday, ',')
                    'loc': _.join($scope.filter.location, ',')
                    'order': $scope.order
                if $scope.filter.lmoney
                    data.lmoney = $scope.filter.lmoney
                if $scope.filter.umoney
                    data.umoney = $scope.filter.umoney

            if backView.stateName == 'home.course.catalogs'
                catalog = $rootScope.catalog
                data =
                    'page': page
                    'perpage': pagesize
                    'query': keyword
                    'cata': catalog.catalog_id
                    'order': $scope.order

            modal.showLoading '', 'message.searching'
            api.searchCourse(data, onSuccess, onError)

        $scope.goSearch = (keyword) ->
            $scope.page = 1

            goSearch($scope.page, $scope.pageSize, keyword)

        # start
        $scope.filter.weekday = JSON.parse(window.localStorage.getItem('weekdays'))
        $scope.filter.location = JSON.parse(window.localStorage.getItem('locations'))

        location_taipei = true
        location_taipei &= _.indexOf($scope.filter.location, '建國') != -1
        location_taipei &= _.indexOf($scope.filter.location, '忠孝') != -1
        location_taipei &= _.indexOf($scope.filter.location, '延平') != -1
        location_taipei &= _.indexOf($scope.filter.location, '大安') != -1

        if location_taipei
            $scope.filter.location.push '台北'

        #console.log $scope.filter
        loadHistory(->)
        $scope.goSearch($stateParams.keyword)

        $ionicPopover.fromTemplateUrl('templates/popover.html',
            scope: $scope
        ).then((popover) ->
            $scope.popover = popover
        )
        $ionicPopover.fromTemplateUrl('templates/popover-history.html',
            scope: $scope
        ).then((popover) ->
            $scope.popoverHistory = popover
        )

        $scope.$on('$ionicView.enter', ->
            #$log.info '$ionicView.enter'
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

            backView = $ionicHistory.backView()
            if backView.stateName == 'home.dashboard'
                $scope.option_visible = true
            else
                $scope.option_visible = false
        )
]