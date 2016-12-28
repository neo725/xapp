module.exports = ['$ionicPlatform', '$timeout', ($ionicPlatform, $timeout) ->
    $ionicPlatform.ready () ->
        if window.cordova and window.cordova.plugins.Keyboard
# Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
# for form inputs)
            cordova.plugins.Keyboard.hideKeyboardAccessoryBar true

            # Don't remove this line unless you know what you are doing. It stops the viewport
            # from snapping when text inputs are focused. Ionic handles this internally for
            # a much nicer keyboard experience.
            cordova.plugins.Keyboard.disableScroll true

        if window.plugins and window.plugins.nativepagetransitions
            # nativetransition
            # then override any default you want
            window.plugins.nativepagetransitions.globalOptions.duration = 500
            window.plugins.nativepagetransitions.globalOptions.iosdelay = 100
            window.plugins.nativepagetransitions.globalOptions.androiddelay = 100
            window.plugins.nativepagetransitions.globalOptions.winphonedelay = 100
            window.plugins.nativepagetransitions.globalOptions.slowdownfactor = 1
            window.plugins.nativepagetransitions.globalOptions.slidePixels = 20
            # these are used for slide left/right only currently
            window.plugins.nativepagetransitions.globalOptions.fixedPixelsTop = 0
            window.plugins.nativepagetransitions.globalOptions.fixedPixelsBottom = 0

        if navigator.splashscreen
            $timeout(() ->
                navigator.splashscreen.hide()
            , 100)
        return
]
