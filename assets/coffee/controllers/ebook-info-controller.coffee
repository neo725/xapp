module.exports = [
    '$rootScope', '$scope', '$stateParams', '$ionicHistory', '$timeout', '$sce', '$translate', 'navigation', 'modal', 'plugins', 'api',
    ($rootScope, $scope, $stateParams, $ionicHistory, $timeout, $sce, $translate, navigation, modal, plugins, api) ->
        $scope.loading = false
        $scope.alreadyAddFavorites = false

        yearmonth = $stateParams.yearmonth
        catalog_id = $stateParams.catalog_id

        alreadyGoBack = false

        $scope.goBack = ->
            alreadyGoBack = true
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.addToFavorite = ($event, ebook) ->
            if $scope.alreadyAddFavorites
                deleteFromFavorites ebook
                return
            $button = $($event.currentTarget)
            $button.find('i').removeClass('sprite-icon-ebook-add-favorite').addClass('sprite-icon-ebook-del-favorite')

            modal.showLoading '', 'message.processing'

            onSuccess = (response) ->
                $scope.alreadyAddFavorites = true
                modal.hideLoading()
                $translate('message.success_to_add_favorite_ebook').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = () ->
                modal.hideLoading()

            api.addEbookFavorite(yearmonth, catalog_id, onSuccess, onError)

        deleteFromFavorites = (ebook) ->
            modal.showLoading '', 'message.processing'

            onSuccess = () ->
                $scope.alreadyAddFavorites = false
                modal.hideLoading()

                $translate('message.success_to_delete_favorite_ebook').then (text) ->
                    plugins.toast.show(text, 'long', 'top')

            onError = () ->
                modal.hideLoading()

            api.deleteFavoriteEbook(ebook.yearmonth, ebook.catalog, onSuccess, onError)

        loadCatalogEbook = (yearmonth, catalog_id) ->
            # $scope.alreadyAddFavorites
            index = _.findIndex($rootScope.ebook_favorites, { yearmonth: yearmonth, catalog: catalog_id })
            $scope.alreadyAddFavorites = (index > -1)
            modal.showLoading '', 'message.data_loading'

            onSuccess = (response) ->
                $scope.ebook = response

                $scope.ebook.safe_intro = $sce.trustAsHtml($scope.ebook.intro)
                $scope.ebook.safe_context = $sce.trustAsHtml($scope.ebook.context)
                $scope.ebook.safe_html = $sce.trustAsHtml($scope.ebook.html)

                $iframe = $(document.getElementById('iframe'))
                $iframe.contents().find('html').html($scope.ebook.html)

                loopTimes = 0
                autoHeight = (maxLoopSecs) ->
                    $timeout ->
                        if alreadyGoBack
                            return
                        loopTimes += 1
                        height = $iframe.contents().find('html').height()
                        $iframe.height(height + 'px')
                        if loopTimes < (maxLoopSecs * 10)
                            autoHeight(maxLoopSecs)
                    , 100

                autoHeight(5)

                modal.hideLoading()
            onError = () ->
                modal.hideLoading()

            api.getCatalogEbook yearmonth, catalog_id, onSuccess, onError

        $scope.$on('$ionicView.enter', (evt, data) ->
            $scope.loading = true

            loadCatalogEbook(yearmonth, catalog_id)

            $scope.loading = false

            $('.ebook-info-content').prepend($('.add-favorite'))
        )
]