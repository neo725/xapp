module.exports = [
    '$scope', '$stateParams', '$ionicHistory', '$timeout', '$sce', '$translate', 'navigation', 'modal', 'plugins', 'api',
    ($scope, $stateParams, $ionicHistory, $timeout, $sce, $translate, navigation, modal, plugins, api) ->
        yearmonth = $stateParams.yearmonth
        catalog_id = $stateParams.catalog_id

        $scope.goBack = ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.addToFavorite = (ebook) ->
            modal.showLoading '', 'message.processing'

            onSuccess = (response) ->
                console.log response
                modal.hideLoading()
                $translate('message.success_to_add_favorite_ebook').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log error
                console.log status_code

            api.addEbookFavorite(yearmonth, catalog_id, onSuccess, onError)

        loadCatalogEbook = (yearmonth, catalog_id) ->
            modal.showLoading '', 'message.data_loading'

            onSuccess = (response) ->
                $scope.ebook = response

                $scope.ebook.safe_intro = $sce.trustAsHtml($scope.ebook.intro)
                $scope.ebook.safe_context = $sce.trustAsHtml($scope.ebook.context)
                $scope.ebook.safe_html = $sce.trustAsHtml($scope.ebook.html)

                $iframe = $(document.getElementById('iframe'))
                $iframe.contents().find('html').html($scope.ebook.html)

                loopTimes = 0
                autoHeight = (maxLookSecs) ->
                    $timeout ->
                        loopTimes += 1
                        height = $iframe.contents().find('html').height()
                        $iframe.height(height + 'px')
                        if loopTimes < (maxLookSecs * 10)
                            autoHeight()
                    , 100

                autoHeight(5)

                modal.hideLoading()
            onError = ->
                modal.hideLoading()

            api.getCatalogEbook yearmonth, catalog_id, onSuccess, onError

        $scope.$on('$ionicView.enter', (evt, data) ->
            loadCatalogEbook(yearmonth, catalog_id)
            #$('.add-favorite').before($('div.scroll'))
            $('.ebook-info-content').prepend($('.add-favorite'))
        )
]