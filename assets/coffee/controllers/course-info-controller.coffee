module.exports = [
    '$rootScope', '$scope', '$stateParams', '$log', '$ionicHistory', '$translate', 'navigation', 'api', 'plugins'
    ($rootScope, $scope, $stateParams, $log, $ionicHistory, $translate, navigation, api, plugins) ->
        shop_id = $stateParams.shop_id
        prod_id = $stateParams.prod_id

        $scope.goBack = () ->
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                navigation.slide('home.dashboard', {}, 'right')

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

                window.localStorage.setItem('favorite_changed', JSON.stringify(data))

            onError = (error) ->
                $log.info error

            if course.isFavorite == 0
                api.addToWish course.Shop_Id, course.Prod_Id, onSuccess, onError
            else
                api.removeFromWish course.Shop_Id, course.Prod_Id, onSuccess, onError

        $scope.addToCart = (course) ->
            $log.info 'addToCart'
            onSuccess = ->
                cart = $rootScope.cart || []
                cart.push course
                $rootScope.cart = cart
                $translate('message.course_add_to_cart_success').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            onError = ->
                $log.info 'error'

            if _.find($rootScope.cart, {'Prod_Id': course.Prod_Id})
                $translate('message.already_exists_in_cart').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
            else
                api.addToCart course.Shop_Id, course.Prod_Id, onSuccess, onError

        getCourse = (shop_id, prod_id) ->
            onSuccess = (response) ->
                $scope.course = response
                if $scope.course.isFavorite == 0
                    $scope.favorite_icon = 'heart-outline@2x.png'
                else
                    $scope.favorite_icon = 'heart@2x.png'
            onError = (->)

            api.getCourse shop_id, prod_id, onSuccess, onError

        getCourse shop_id, prod_id
]