constants = require('../common/constants')

# plugin : $cordovaGlobalization
# http://ngcordova.com/docs/plugins/globalization/

module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicPlatform', '$cordovaDevice', '$cordovaGlobalization', '$cordovaToast', '$cordovaBadge', 'navigation', 'modal', 'api'
    ($rootScope, $scope, $translate, $ionicPlatform, $cordovaDevice, $cordovaGlobalization, $cordovaToast, $cordovaBadge, navigation, modal, api) ->

        network_offline = false

        $translate.use constants.DEFAULT_LOCALE

        $rootScope.callFCMGetToken = () ->
            if typeof FCMPlugin == 'undefined'
                return

            # Google FCM
            # Keep in mind the function will return null if the token has not been established yet.
            FCMPlugin.getToken(
                (token) ->
                    console.log 'FCM token : ' + token
#                    onSuccess = (response) ->
#                        $cordovaToast.show('Notification token registered', 'long', 'top')
                    onSuccess = (->)
                    onError = (error, status) ->
                        $cordovaToast.show('Error Registering notification token', 'long', 'top')
                        console.log status
                        console.log error
                    uuid = $cordovaDevice.getUUID()
                    api.registerToken(uuid, token, onSuccess, onError)
                , ((err) ->)
            )

        $rootScope.loadCart = ->
            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.carts = response.list
            onError = (error, status_code) ->
                modal.hideLoading()
                console.log status_code
                console.log error

            modal.showLoading('', 'message.data_loading')
            api.getCartList(1, 500, onSuccess, onError)

        $rootScope.loadWish = ->
            onSuccess = (response) ->
                modal.hideLoading()
                $rootScope.wish = response.list

            onError = (error, status_code) ->
                modal.hideLoading()
                console.log status_code
                console.log error

            modal.showLoading('', 'message.data_loading')
            api.getWishList(1, 500, onSuccess, onError)

        $rootScope.getMemberData = (successFn, errorFn) ->
            console.log 'index-controller -> getMemberData'
            onSuccess = (response) ->
                modal.hideLoading()
                data =
                    memb_name: response.Memb_Name
                    memb_email: response.Memb_EMail
                    memb_mobile: response.Memb_Mobile
                    memb_ident: response.Memb_Ident
                    memb_status: response.Memb_Status

                console.log 'data :'
                console.log data

                $rootScope.member = data

                if $rootScope.member and $rootScope.member.memb_status == 'wait'
                    $rootScope.token_temp = window.localStorage.getItem("token")
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
            console.log 'index-controller -> checkDefaultState'

            if token == undefined
                token = window.localStorage.getItem('token')

            if token == null or token == "null"
                navigation.flip 'login', {}, 'left'
            else
                onSuccess = () ->
                    $rootScope.loadCart()
                    $rootScope.loadWish()
                    $rootScope.callFCMGetToken()

                    if redirectToDashboard
                        navigation.flip 'home.dashboard', {}, 'left'

                $rootScope.getMemberData(onSuccess, (->))

        $ionicPlatform.ready(->
            console.log 'index-controller -> $ionicPlatform.ready'

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
                        $cordovaToast.show('You got new notification', 'long', 'top')
                        console.log data
                        #$cordovaBadge.set 10

                    , (msg) ->
                        console.log 'onNotification callback successfully registered: ' + msg
                    , (err) ->
                        console.log 'Error registering onNotification callback: ' + err
                )
        )

        $scope.$on('$ionicView.enter', (evt, data) ->
            console.log 'index-controller -> $ionicView.enter'
            token = window.localStorage.getItem('token')
            if $rootScope.member == undefined and token
                checkDefaultState(token, false)
        )

#        $rootScope.$on('network.none', ->
#            modal.showMessage('message.no_network')
#        )
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
