module.exports = ['$ionicPlatform', '$timeout', '$log', '$translate', 'plugins', ($ionicPlatform, $timeout, $log, $translate, plugins) ->
    $ionicPlatform.ready () ->
        prev_network_state = 'none'

        offline = () ->
            prev_network_state = 'offline'
            $translate(['errors.network_offline', 'popup.ok']).then (translator) ->
                plugins.notification.alert(
                    translator['errors.network_offline'],
                    (->),
                    '',
                    translator['popup.ok']
                )

        online = () ->
            serve_prev_network_state = prev_network_state
            prev_network_state = 'online'

            if serve_prev_network_state = 'offline'
                window.location.reload(true)

        document.addEventListener 'offline', offline, false
        document.addEventListener 'online', online, false

        if window.cordova and window.cordova.plugins.Keyboard
            # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
            # for form inputs)
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar true

            # Don't remove this line unless you know what you are doing. It stops the viewport
            # from snapping when text inputs are focused. Ionic handles this internally for
            # a much nicer keyboard experience.
            cordova.plugins.Keyboard.disableScroll true

#        if window.plugins and window.plugins.nativepagetransitions
#            # nativetransition
#            # then override any default you want
#            window.plugins.nativepagetransitions.globalOptions.duration = 500
#            window.plugins.nativepagetransitions.globalOptions.iosdelay = 100
#            window.plugins.nativepagetransitions.globalOptions.androiddelay = 100
#            window.plugins.nativepagetransitions.globalOptions.winphonedelay = 100
#            window.plugins.nativepagetransitions.globalOptions.slowdownfactor = 1
#            window.plugins.nativepagetransitions.globalOptions.slidePixels = 20
#            # these are used for slide left/right only currently
#            window.plugins.nativepagetransitions.globalOptions.fixedPixelsTop = 0
#            window.plugins.nativepagetransitions.globalOptions.fixedPixelsBottom = 0

        if window.MobileAccessibility
            window.MobileAccessibility.usePreferredTextZoom false

        if navigator.splashscreen
            $timeout(() ->
                navigator.splashscreen.hide()
            , 100)
        return
]
