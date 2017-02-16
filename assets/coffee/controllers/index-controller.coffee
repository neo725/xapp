constants = require('../common/constants')

# plugin : $cordovaGlobalization
# http://ngcordova.com/docs/plugins/globalization/

module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicPlatform', '$cordovaDevice', '$cordovaGlobalization', '$cordovaToast',
    '$cordovaLocalNotification', '$cordovaVibration', '$cordovaBadge', '$log', 'navigation', 'modal', 'api',
    ($rootScope, $scope, $translate, $ionicPlatform, $cordovaDevice, $cordovaGlobalization, $cordovaToast,
        $cordovaLocalNotification, $cordovaVibration, $cordovaBadge, $log, navigation, modal, api) ->

        $rootScope.fromNotification = false
        network_offline = false

        $translate.use constants.DEFAULT_LOCALE

        $rootScope.callFCMGetToken = () ->
            if typeof FCMPlugin == 'undefined'
                return

            # Google FCM
            # Keep in mind the function will return null if the token has not been established yet.
            FCMPlugin.getToken(
                (token) ->
                    $log.info 'FCM token : ' + token

                    onSuccess = (->)
                    onError = () ->
                        $cordovaToast.show('Error Registering notification token', 'long', 'top')

                    uuid = $cordovaDevice.getUUID()
                    api.registerToken(uuid, token, onSuccess, onError)
                , ((err) ->)
            )

        $rootScope.loadCart = ->
            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.carts = response.list
            onError = () ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_loading')
            api.getCartList(1, 500, onSuccess, onError)

        $rootScope.loadWish = ->
            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.wish = response.list

            onError = () ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_loading')
            api.getWishList(1, 500, onSuccess, onError)

        $rootScope.getMemberData = (successFn, errorFn) ->
            $log.info 'index-controller -> getMemberData'
            onSuccess = (response) ->
                modal.hideLoading()

                data =
                    memb_id: response.Memb_Id
                    memb_name: response.Memb_Name
                    memb_email: response.Memb_EMail
                    memb_mobile: response.Memb_Mobile
                    memb_ident: response.Memb_Ident
                    memb_status: response.Memb_Status
                    memb_birthday: response.Memb_BirthDay
                    memb_address: response.Memb_AddHome
                    memb_gender: response.Memb_Gender

                $rootScope.member = data

                if $rootScope.member and $rootScope.member.memb_status == 'wait'
                    $rootScope.token_temp = window.localStorage.getItem("token")
                    $rootScope.member.from = 'register'
                    window.localStorage.removeItem("token")

                    navigation.slide 'main.phoneconfirm', {}, 'left'
                else
                    (successFn || (->))(data)

            onError = (error, status_code) ->
                modal.hideLoading()
                errorFn(error, status_code)

            modal.showLoading('', 'message.data_loading')
            api.getMemberData(onSuccess, onError)

        checkDefaultState = (token, redirectToDashboard = true) ->
            $log.info 'index-controller -> checkDefaultState'

            if token == undefined
                token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.slide 'login', {}, 'left'
            else
                onSuccess = () ->
#                    $rootScope.loadCart()
#                    $rootScope.loadWish()
                    $rootScope.callFCMGetToken()

                    if redirectToDashboard
                        navigation.slide 'home.dashboard', {}, 'left'

                $rootScope.getMemberData(onSuccess, (->))

        getMessageInfo = (messageId) ->
            modal.showLoading('', 'message.data_loading')

            goMessageInfo = (message) ->
                params =
                    'type': message.m_type
                    'message_id': message.messageId
                navigation.slide 'home.member.message-info', params, 'left'
            onSuccess = (response) ->
                modal.hideLoading()
                goMessageInfo response
            onError = () ->
                modal.hideLoading()

            api.getMessage messageId, onSuccess, onError

        $ionicPlatform.ready(->
            $log.info 'index-controller -> $ionicPlatform.ready'

            # lock the device orientation
            if window.screen.lockOrientation
                window.screen.lockOrientation('portrait-primary')

            if navigator.globalization
                $cordovaGlobalization.getPreferredLanguage().then(
                    (language) ->
                        languages = {
                            'zh-Hant': 'zh-Hant'
                            'zh-TW': 'zh-Hant'
                            'zh-Hans': 'zh-Hans'
                            'zh-CN': 'zh-Hans'
                            'en-US': 'en-US'
                        }
                        if (language.value of languages)
                            $translate.use(languages[language.value])
                        else
                            $translate.use(constants.DEFAULT_LOCALE)
                ,
                    -> $translate.use(constants.DEFAULT_LOCALE)
                )
            else
                $translate.use(constants.DEFAULT_LOCALE)


            if typeof FCMPlugin != 'undefined'
                FCMPlugin.onNotification(
                    (data) ->
                        $log.info 'onNotification DATA received'
                        $log.info data
                        if data.wasTapped
                            $log.warn 'FCMPlugin.onNotification...'

                            $rootScope.fromNotification = true

                            getMessageInfo data.mid
                        else
                            $cordovaLocalNotification.schedule(
                                id: 1,
                                title: data['title'],
                                text: data['body'],
                                icon: 'fcm_push_icon'
                            ).then () ->
    #                            # Vibrate
    #                            $cordovaVibration.vibrate([500, 500])
                                $cordovaToast.show(data['title'], 'long', 'top')

                            #$cordovaBadge.set 10
                    , (msg) ->
                        $log.info 'onNotification callback successfully registered: ' + msg
                        $scope.$broadcast 'index-controller.onNotificationRegistered'
                    , (err) ->
                        $log.info 'Error registering onNotification callback: ' + err
                        $scope.$broadcast 'index-controller.onNotificationRegistered'
                )
        )

        $scope.$on('$ionicView.enter', () ->
            $log.info 'index-controller -> $ionicView.enter'
            token = window.localStorage.getItem('token')
            if $rootScope.member == undefined and token
                checkDefaultState(token, false)

            if token == undefined or token == 'undefined'
                navigation.slide('login', {}, 'right')
        )

        $rootScope.$on('$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
            $log.info 'index-controller -> $stateChangeSuccess -> Entered to view'
            # fix ion-nav-bar apply nav-bar-tabs-top but has no tabs actually
            navbar = $('ion-nav-bar.nav-bar-tabs-top')
            tabs = $('div.tabs:not([nav-bar-tabs-top-ignore]):visible')

            navbar.removeClass('nav-bar-tabs-top')

        )

        document.addEventListener('offline', () ->
            modal.showMessage('message.no_network')
            network_offline = true
        , false)
        document.addEventListener('online', () ->
            if network_offline
                checkDefaultState()
                network_offline = false
        , false)

        return
]
