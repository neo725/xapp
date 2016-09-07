module.exports = [
    '$scope', '$log', '$ionicHistory', 'navigation'
    ($scope, $log, $ionicHistory, navigation) ->
        $scope.course =
            title: '測試課程標題 - 測試課程標題 - 測試課程標題'
            header_image: 'http://www.sce.pccu.edu.tw/mobile/image/customer/med20160426111315115.jpg'

        #$scope.favorite_icon = 'heart-outline@2x.png'
        $scope.favorite_icon = 'heart@2x.png'

        $scope.goBack = () ->
            params = $ionicHistory.backView().stateParams

            if params.keyword
                navigation.slide('home.course.search', {keyword: params.keyword}, 'right')
]