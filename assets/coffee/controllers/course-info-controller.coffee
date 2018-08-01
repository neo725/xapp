module.exports = [
    '$rootScope', '$scope', '$stateParams', '$ionicModal', '$log', '$ionicHistory', '$translate', '$cordovaSocialSharing',
    'navigation', 'modal', 'api', 'plugins'
    ($rootScope, $scope, $stateParams, $ionicModal, $log, $ionicHistory, $translate, $cordovaSocialSharing,
        navigation, modal, api, plugins) ->
            shop_id = $stateParams.shop_id
            prod_id = $stateParams.prod_id

            $scope.goBack = () ->
                backView = $ionicHistory.backView()

                if backView
                    navigation.slide(backView.stateName, backView.stateParams, 'right')
                else
                    navigation.slide('home.dashboard', {}, 'right')

            $scope.socialSharing = (course) ->
                message = "#{course.Prod_Name} #{course.Prod_SubName}"
                subject = null
                file = null
                link = course.murl

                success = (result) ->
                    $log.info result
                error = (error) ->
                    $log.error error

                $cordovaSocialSharing
                .share(message, subject, file, link)
                .then(success, error)

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

                onError = (->)

                if course.isFavorite == 0
                    api.addToWish course.Shop_Id, course.Prod_Id, onSuccess, onError
                else
                    api.removeFromWish course.Shop_Id, course.Prod_Id, onSuccess, onError

            $scope.checkIsInCart = (course) ->
                if not course
                    return false
                carts = $rootScope.carts || []
                if _.find(carts, { 'Prod_Id': course.Prod_Id })
                    return true
                return false

            $scope.addToCart = (course) ->
                onSuccess = ->
                    cart = $rootScope.carts || []
                    cart.push course
                    $rootScope.carts = cart
                    $translate('message.course_add_to_cart_success').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                onError = (->)

                if _.find($rootScope.carts, {'Prod_Id': course.Prod_Id})
                    $translate('message.already_exists_in_cart').then (text) ->
                        plugins.toast.show(text, 'long', 'top')
                else
                    if course.isCanBuy == 0
                        $translate(['message.course_cant_buy', 'popup.ok']).then (translator) ->
                            plugins.notification.alert(
                                translator['message.course_cant_buy'],
                                (->),
                                '',
                                translator['popup.ok']
                            )
                        return
                    api.addToCart course.Shop_Id, course.Prod_Id, onSuccess, onError

            $scope.getTimePart = (part, time_value) ->
                if time_value
                    weekday_part = time_value.split(' ')
                    time_part = weekday_part[1].split('~')
                    switch part
                        when 'weekday'
                            weekday_part = weekday_part[0]
                            if weekday_part.indexOf('、') > -1
                                weekday_part = weekday_part.split('、')
                                return weekday_part
                            else if weekday_part.indexOf('~') > -1
                                weekday_part = weekday_part.split('~')
                                weekday_part.splice(1, 0, '~')
                                return weekday_part
                            else
                                v = []
                                v.push weekday_part
                                return v

                        when 'start'
                            return time_part[0]
                        when 'end'
                            return time_part[1]
                return ''

            $scope.parseHTML = (str, targetClass) ->
                $this = $(".card-container > #{targetClass}")
                if str
                    $this.show()
                    return str.replace(/(?:\r\n|\r|\n)/g, '<br />')
                $this.hide()
                return str

            $scope.showPriceModal = () ->
                if $scope.course.priceList
                    $scope.modalPriceList.show()

            $scope.onlyForBuyInService = (course) ->
                $translate('message.course_only_for_buy_in_service').then (text) ->
                    plugins.toast.show(text, 'long', 'top')

            getCourse = (shop_id, prod_id) ->
                onSuccess = (response) ->
                    modal.hideLoading()
                    $scope.course = response
                    $scope.desc = $scope.course.xmlDiscription.Discription
                    $rootScope.priceList = $scope.course.priceList

                    $scope.course.weekdays = $scope.getTimePart('weekday', $scope.course.Prod_ClsTime)
                    # $scope.course.weekdays = ['一', '三', '四']
                    # $log.info $scope.course.weekdays

                    if $scope.course.isFavorite == 0
                        $scope.favorite_icon = 'heart-outline@2x.png'
                    else
                        $scope.favorite_icon = 'heart@2x.png'
                onError = () ->
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
