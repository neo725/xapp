module.exports = [
    '$scope', '$stateParams', '$log', '$cordovaToast', '$timeout', 'navigation', 'modal', 'api'
    ($scope, $stateParams, $log, $cordovaToast, $timeout, navigation, modal, api) ->
        loadTimes = 0
        $scope.noMoreItemsAvailable = false

        $scope.keyword = $stateParams.keyword
        #$scope.keep_image_name = 'heart-outline@2x.png'

        $scope.goBack = () ->
            navigation.slide 'home.dashboard', {}, 'right'

        $scope.keywordFocus = () ->

        $scope.loadMore = () ->
            $cordovaToast.show('load more', 'long', 'top')
            loadTimes += 1
            if loadTimes == 3
                $scope.noMoreItemsAvailable = true;
            $timeout () ->

                $scope.$broadcast('scroll.infiniteScrollComplete')
            , 3000

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
                    if index % 2 == 0
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
]