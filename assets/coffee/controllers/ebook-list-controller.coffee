module.exports = [
    '$scope', '$ionicHistory', '$translate', 'navigation', 'modal', 'plugins', 'api',
    ($scope, $ionicHistory, $translate, navigation, modal, plugins, api) ->
        $scope.intro = {}

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.parseUrlToPara = (url) ->
            para = {}
            regexCatalogId = /page=([^&]*)/ig
            regexApply = /apply=([^&]*)/ig

            match = regexCatalogId.exec url
            if match
                para.catalog_id = match[1]
            match = regexApply.exec url
            if match
                para.apply = match[1]

            return para

        $scope.onItemDelete = (ebook) ->
            para = $scope.parseUrlToPara(ebook.web_url)

            modal.showLoading '', 'message.processing'

            onSuccess = (response) ->
                console.log response
                modal.hideLoading()
                $translate('message.success_to_delete_favorite_ebook').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
                index = _.findIndex($scope.favorites, { 'web_url': ebook.web_url })
                if index > -1
                    $scope.favorites.splice(index, 1)
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log error
                console.log status_code

            api.deleteFavoriteEbook(para.apply, para.catalog_id, onSuccess, onError)

        loadEbookIntro = () ->
            modal.showLoading('', 'message.data.loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.intro =
                    title: response.title
                    imgurl: response.imgurl
                    content: response.content
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log error
                console.log status_code

            api.getEbookIntro(onSuccess, onError)

        loadCurrentEbook = () ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.ebooks = response.list
            onError = ->
                modal.hideLoading()

            api.getCurrentEbooks(onSuccess, onError)

        loadCatalogEbooks = (page, perpage) ->
            modal.showLoading('', 'message.data_loading')

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.catalogs = response.list
            onError = ->
                modal.hideLoading()

            api.getCatalogEbooks(page, perpage, onSuccess, onError)

        loadFavoriteEbooks = (page, perpage) ->
            modal.showLoading '', 'message.data_loading'

            onSuccess = (response) ->
                modal.hideLoading()
                $scope.favorites = response.list
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log error
                console.log status_code

            api.getMyFavoriteEbooks(page, perpage, onSuccess, onError)

        loadEbookIntro()
        loadCurrentEbook()
        loadCatalogEbooks(1, 5)
        $scope.$on('$ionicView.enter', (evt, data) ->
            loadFavoriteEbooks(1, 500)
        )
]