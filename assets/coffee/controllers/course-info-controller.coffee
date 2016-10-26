module.exports = [
    '$rootScope', '$scope', '$stateParams', '$ionicModal', '$log', '$ionicHistory', '$translate', 'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $stateParams, $ionicModal, $log, $ionicHistory, $translate, navigation, modal, api, plugins) ->
        shop_id = $stateParams.shop_id
        prod_id = $stateParams.prod_id

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

        $scope.getDatePart = (date) ->
            return moment(date).format('YYYY/M/DD')

        $scope.addOrRemoveFromWish = (course) ->
            onSuccess = () ->
                if course.isFavorite == 0
                    $scope.favorite_icon = 'heart@2x.png'
                    course.isFavorite = 1
                    $translate('message.favorite_added').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                else
                    $scope.favorite_icon = 'heart-outline@2x.png'
                    course.isFavorite = 0
                    $translate('message.favorite_removed').then (text) ->
                        plugins.toast.show(text, 'long', 'top')

                data =
                    prod_id: course.Prod_Id
                    is_favorite: course.isFavorite

                #window.localStorage.setItem('favorite_changed', JSON.stringify(data))
                $rootScope.favorite_changed = data

            onError = (error) ->
                $log.info error

            if course.isFavorite == 0
                api.addToWish course.Shop_Id, course.Prod_Id, onSuccess, onError
            else
                api.removeFromWish course.Shop_Id, course.Prod_Id, onSuccess, onError

        $scope.addToCart = (course) ->
            onSuccess = ->
                cart = $rootScope.carts || []
                cart.push course
                $rootScope.carts = cart
                $translate('message.course_add_to_cart_success').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = ->
                $log.info 'error'

            if _.find($rootScope.carts, {'Prod_Id': course.Prod_Id})
                $translate('message.already_exists_in_cart').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            else
                api.addToCart course.Shop_Id, course.Prod_Id, onSuccess, onError

        $scope.getTimePart = (part, time_value) ->
            if time_value
                weekday_part = time_value.split(' ')
                time_part = weekday_part[1].split('~')
                switch part
                    when 'weekday'
                        return weekday_part[0]
                    when 'start'
                        return time_part[0]
                    when 'end'
                        return time_part[1]
            return ''

        $scope.parseHTML = (str) ->
            if str
                return str.replace(/(?:\r\n|\r|\n)/g, '<br />')
            return str

        $scope.showPriceModal = () ->
            if $scope.course.priceList
                $scope.modalPriceList.show()

        getCourse = (shop_id, prod_id) ->
            onSuccess = (response) ->
                modal.hideLoading()
                $scope.course = response
                $scope.desc = $scope.course.xmlDiscription.Discription
                $rootScope.priceList = $scope.course.priceList

                if $scope.course.isFavorite == 0
                    $scope.favorite_icon = 'heart-outline@2x.png'
                else
                    $scope.favorite_icon = 'heart@2x.png'
            onError = ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_loading')
            api.getCourse shop_id, prod_id, onSuccess, onError

        getCourse shop_id, prod_id

        $ionicModal.fromTemplateUrl('templates/modal-price-list.html',
            scope: $scope
            animation: 'slide-in-up'
        ).then((modal) ->
            $scope.modalPriceList = modal
        )
]