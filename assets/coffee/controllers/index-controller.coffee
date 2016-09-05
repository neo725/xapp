constants = require('../common/constants')

# plugin : $cordovaGlobalization
# http://ngcordova.com/docs/plugins/globalization/

module.exports = [
    '$state', '$translate', '$log', '$ionicPlatform', '$cordovaGlobalization', '$cordovaToast', '$cordovaBadge', 'modal', 'api'
    ($state, $translate, $log, $ionicPlatform, $cordovaGlobalization, $cordovaToast, $cordovaBadge, modal, api) ->
        $translate.use constants.DEFAULT_LOCALE

        checkDefaultState = () ->
            #window.localStorage.removeItem("token")
            token = window.localStorage.getItem('token')

            if token == null or token == "null"
                $state.go 'login'
            else
                $state.go 'home.dashboard'

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

            # Google FCM
            # Keep in mind the function will return null if the token has not been established yet.
            FCMPlugin.getToken(
                (token) ->
                    $log.info token
                    onSuccess = (response) ->
                        $log.info response
                    onError = () ->
                        $cordovaToast.show('token register error', 'long', 'top')
                    api.registerToken(token, onSuccess, onError)
                , ((err) ->)
            )
            FCMPlugin.onNotification(
                (data) ->
                    if data.wasTapped
                        $log.info 'tapped : ' + data
                    else
                        $log.info '2 :' + data

                    $cordovaBadge.registerPermission((granted) ->
                        console.log('Permission has been granted: ' + granted)
                        if granted
                            $cordovaBadge.set 10
                    )

                , (msg) ->
                    $log.info 'onNotification callback successfully registered: ' + msg
                , (err) ->
                    $log.info 'Error registering onNotification callback: ' + err
            )
#            $cordovaBadge.get().then((badge) ->
#                $log.info 'current badge = ' + badge
#            , (err) ->
#                $log.info 'no permission'
#            )
            $cordovaToast.show('Here is a message', 'long', 'top')
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
