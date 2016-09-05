module.exports = ['$scope', '$stateParams', '$log', 'navigation', 'modal', 'api'
    ($scope, $stateParams, $log, navigation, modal, api) ->
        $scope.keyword = $stateParams.keyword
        $scope.keep_image_name = 'heart-outline@2x.png'

        $scope.goBack = () ->
            navigation.slide 'home.dashboard', {}, 'right'

        $scope.keywordFocus = () ->

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

            data =
                'perpage': 20
                'query': keyword
                #'wday': '一,二,三,四,五,六,日'
                'wday': '一,二'
                'loc': '建國,忠孝,延平,大安'

            modal.showLoading '', 'message.searching'
            api.searchCourse(data, onSuccess, onError)

        $scope.goSearch($stateParams.keyword)
]