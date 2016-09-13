constants = require('../common/constants')

# plugin : $cordovaGlobalization
# http://ngcordova.com/docs/plugins/globalization/

module.exports = [
    '$rootScope', '$state', '$translate', '$log', '$ionicNativeTransitions', '$ionicPlatform', '$cordovaDevice', '$cordovaGlobalization', '$cordovaToast', '$cordovaBadge', 'modal', 'api'
    ($rootScope, $state, $translate, $log, $ionicNativeTransitions, $ionicPlatform, $cordovaDevice, $cordovaGlobalization, $cordovaToast, $cordovaBadge, modal, api) ->
        $rootScope.container = {}

        $translate.use constants.DEFAULT_LOCALE

        $rootScope.callFCMGetToken = () ->
            # Google FCM
            # Keep in mind the function will return null if the token has not been established yet.
            FCMPlugin.getToken(
                (token) ->
                    $log.info token
                    onSuccess = (response) ->
                        $cordovaToast.show('Notification token registered', 'long', 'top')
                    onError = (error) ->
                        $cordovaToast.show('Error Registering  notification token', 'long', 'top')
                        $log.info error
                    uuid = $cordovaDevice.getUUID()
                    api.registerToken(uuid, token, onSuccess, onError)
            , ((err) ->)
            )

        checkDefaultState = () ->
            $log.info 'checkDefaultState'
            #window.localStorage.removeItem("token")
            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                #$state.go 'login'
                $ionicNativeTransitions.stateGo 'login', {}, {},
                        "type": "flip",
                        "direction": "left", # 'left|right|up|down', default 'left' (which is like 'next')
                    "duration": 1500, # in milliseconds (ms), default 400
            else
                $rootScope.callFCMGetToken()
                #$state.go 'home.dashboard'
                $ionicNativeTransitions.stateGo 'home.dashboard', {}, {},
                    "type": "flip",
                    "direction": "left", # 'left|right|up|down', default 'left' (which is like 'next')
                    "duration": 1500, # in milliseconds (ms), default 400

        $ionicPlatform.ready(->

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

            checkDefaultState()

            FCMPlugin.onNotification(
                (data) ->
                    $cordovaToast.show('You got new notification', 'long', 'top')

                    $cordovaBadge.set 10

                , (msg) ->
                    $log.info 'onNotification callback successfully registered: ' + msg
                , (err) ->
                    $log.info 'Error registering onNotification callback: ' + err
            )

            #$cordovaToast.show('Here is a message', 'long', 'top')
        )

#        $rootScope.$on('network.none', ->
#            modal.showMessage('message.no_network')
#        )
        document.addEventListener('offline', () ->
            modal.showMessage('message.no_network')
        , false)
        document.addEventListener('online', () ->
            checkDefaultState()
        , false)

]
