constants = require('../common/constants')

# plugin : $cordovaGlobalization
# http://ngcordova.com/docs/plugins/globalization/

module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicPlatform', '$cordovaDevice', '$cordovaGlobalization', '$cordovaToast',
    '$cordovaLocalNotification', '$cordovaVibration', '$cordovaBadge', '$log', '$timeout',
    'navigation', 'modal', 'api', 'user', 'CacheFactory',
    ($rootScope, $scope, $translate, $ionicPlatform, $cordovaDevice, $cordovaGlobalization, $cordovaToast,
        $cordovaLocalNotification, $cordovaVibration, $cordovaBadge, $log, $timeout,
        navigation, modal, api, user, CacheFactory) ->

        $rootScope.fcm_topics_member_registered = false

        network_offline = false

        $translate.use constants.DEFAULT_LOCALE

        if not CacheFactory.get('messageCache')
            opts =
                storageMode: 'sessionStorage'
            CacheFactory.createCache('messageCache', opts)
        messageCache = CacheFactory.get('messageCache')

        $rootScope.callFCMGetToken = () ->
            $log.info '[[[ FCM ]]] $rootScope.callFCMGetToken()......'
            if typeof window.FirebasePlugin == 'undefined'
                return
            try_times = 0

            getTheToken = ->
                # Google FCM
                # Keep in mind the function will return null if the token has not been established yet.
                window.FirebasePlugin.getToken(
                    (fcm_token) ->
                        fcm_token = fcm_token.token if fcm_token.token

                        platform = $cordovaDevice.getPlatform().toLowerCase()
                        uuid = $cordovaDevice.getUUID()

                        $log.info '[[[ FCM.getToken() ]]] fcm_token : ' + fcm_token
                        $log.info '[[[ FCM.getToken() ]]] platform : ' + platform

                        onSuccess = () ->
                            window.localStorage.setItem('device_token', fcm_token)
                            registerFirebaseNotification()
                        onError = () ->
                            $cordovaToast.show('Error registering notification token', 'long', 'top')

                        callRegisterDeviceToken = (fcm_token) ->
                            api.registerDeviceToken platform, uuid, fcm_token, onSuccess, onError

                        if fcm_token == null and try_times < 3
                            $timeout(getTheToken, 1000)
                            try_times += 1
                        else
                            if fcm_token == null
                                $cordovaToast.show('Error get notification token', 'long', 'top')
                            else

#                                window.FirebasePlugin.onTokenRefresh(
#                                    (fcm_token) ->
#                                        fcm_token = fcm_token.token if fcm_token.token
#
#                                        deleteDeviceToken = (func) ->
#                                            onSuccess = () ->
#                                                modal.hideLoading()
#                                                window.localStorage.removeItem("device_token")
#
#                                                func()
#                                            onError = ->
#                                                modal.hideLoading()
#
#                                            token = window.localStorage.getItem('device_token')
#                                            if token == null
#                                                func()
#                                            else
#                                                modal.showLoading '', 'message.logging'
#                                                api.deleteDeviceToken token, onSuccess, onError
#
#                                        deleteDeviceToken(->
#                                            callRegisterDeviceToken(fcm_token)
#                                        )
#                                , (err) ->
#                                    $log.info 'window.FirebasePlugin.onTokenRefresh() error : ' + err
#                                )

                                #api.registerDeviceToken(platform, uuid, fcm_token, onSuccess, onError)
                                callRegisterDeviceToken(fcm_token)
                    , (err) ->
                        $log.info 'window.FirebasePlugin.getToken() error : ' + err
                )

            if ionic.Platform.isAndroid()
                getTheToken()
            else
                window.FirebasePlugin.grantPermission(()->
                    getTheToken()
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

        $rootScope.registerFCMTopics = (topic_name, successFn) ->
            if typeof window.FirebasePlugin == 'undefined'
                return

            $log.info "prepare to window.FirebasePlugin.subscribe('#{topic_name}')"
            success = () ->
                $log.info "window.FirebasePlugin.subscribe('#{topic_name}') successed!"
                if successFn
                    successFn()
            error = (->)

            #FCMPlugin.subscribeToTopic(topic_name, success, error)
            window.FirebasePlugin.subscribe(topic_name, success, error)

        $rootScope.unregisterFCMTopics = (topic_name, successFn) ->
            if typeof window.FirebasePlugin == 'undefined'
                return

            success = () ->
                if successFn
                    successFn()
            error = (->)

            #FCMPlugin.unsubscribeFromTopic(topic_name, success, error)
            window.FirebasePlugin.unsubscribe(topic_name, success, error)

        $rootScope.getMemberData = (successFn, errorFn) ->
            $log.info 'index-controller -> getMemberData'
            onSuccess = (response) ->
                modal.hideLoading()

                # register fcm topics
                if $rootScope.fcm_topics_member_registered == false
                    success = () ->
                        $rootScope.fcm_topics_member_registered = true
                    $rootScope.registerFCMTopics 'member', success

                # proccess member data
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
                    #$rootScope.token_temp = window.localStorage.getItem("token")
                    window.sessionStorage.setItem('token', window.localStorage.getItem('token'))
                    $rootScope.member.from = 'register'
                    window.localStorage.removeItem("token")

                    navigation.slide 'main.phoneconfirm', {}, 'left'
                else
                    (successFn || (->))(data)

            onError = (error, status_code) ->
                modal.hideLoading()
                errorFn(error, status_code)

            if user.getIsGuest() == false
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

        getMessageInfo = (groupId) ->
            modal.showLoading('', 'message.data_loading')

            goMessageInfo = (message) ->
                messageCache.put "g-#{message.group_id}", message
                params =
                    'type': message.m_type
                    'group_id': message.group_id
                navigation.slide 'home.member.message-info', params, 'left'
            onSuccess = (response) ->
                modal.hideLoading()
                goMessageInfo response
            onError = () ->
                modal.hideLoading()

            api.getMessage groupId, onSuccess, onError

        registerFirebaseNotification = () ->
            window.FirebasePlugin.onNotificationOpen(
                (data) ->
                    $log.info 'window.FirebasePlugin.onNotificationOpen'
                    $log.info 'notification :'
                    $log.info data

                    if data.tap
                        $log.warn 'window.FirebasePlugin.onNotificationOpen...goto...' + data.mid

                        getMessageInfo data.mid
                    else
                        $translate(['title.notification', 'message.notification_received']).then (translator) ->
                            title = translator['title.notification']
                            body = translator['message.notification_received']

                            $cordovaLocalNotification.schedule(
                                id: 1,
                                title: title,
                                text: body,
                                icon: 'fcm_push_icon'
                            ).then () ->
                                # Vibrate
                                $cordovaVibration.vibrate([500, 500])
                                $cordovaToast.show(body, 'long', 'top')
                    badge = 0
                    if data['badge']
                        badge = parseInt(data['badge'])
                        if badge == 0
                            $cordovaBadge.clear()
                        else
                            $cordovaBadge.set(badge)
            )

        registerNotification = () ->
            FCMPlugin.onNotification(
                (data) ->
                    $log.info 'onNotification DATA received'
                    $log.info data
                    if data.wasTapped
                        # https://github.com/fechanique/cordova-plugin-fcm/issues/106
                        # "priority":"high", //If not set, notification won't be delivered on completely closed iOS app and
                        # "click_action":"FCM_PLUGIN_ACTIVITY", //Must be present for Android
                        $log.warn 'FCMPlugin.onNotification...'

                        getMessageInfo data.mid
                    else
                        $translate(['title.notification', 'message.notification_received']).then (translator) ->
                            title = translator['title.notification']
                            body = translator['message.notification_received']

                            $cordovaLocalNotification.schedule(
                                id: 1,
                                title: title,
                                text: body,
                                icon: 'fcm_push_icon'
                            ).then () ->
                                # Vibrate
                                $cordovaVibration.vibrate([500, 500])
                                $cordovaToast.show(body, 'long', 'top')
                    badge = 0
                    if data['badge']
                        badge = parseInt(data['badge'])
                        if badge == 0
                            $cordovaBadge.clear()
                        else
                            $cordovaBadge.set(badge)
            , (msg) ->
                $log.warn '*** onNotification callback successfully registered: ' + msg
                sendBroadcast = () ->
                    $scope.$broadcast 'index-controller.onNotificationRegistered'
                sendBroadcast()
            , (err) ->
                $log.error '*** Error registering onNotification callback: ' + err
                $scope.$broadcast 'index-controller.onNotificationRegistered'
            )

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
        )

        $scope.$on('$ionicView.enter', () ->
            $log.info 'index-controller -> $ionicView.enter'
            token = window.localStorage.getItem('token')
            if not $rootScope.member and token
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
