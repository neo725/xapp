module.exports = ->
    plugins = {
        statusBar: {isVisible: true, show: (->), hide: (->)}

        transitions: {flip: ->}

        device:
            model: 'iPhone5,1'

        toast:
            'show': (->)

        notification:
            'alert': (->)
            'confirm': (->)

        clipboard: null
    }

    ionic.Platform.ready(->
        if window.plugins

            if StatusBar
                plugins.statusBar = StatusBar
                # StatusBar.styleDefault()
                # StatusBar.overlaysWebView(true)

            plugins.toast = window.plugins.toast

        if window.cordova and window.cordova.plugins
            plugins.clipboard = window.cordova.plugins.clipboard

        if navigator and navigator.notification
            plugins.notification = navigator.notification

        if not window.cordova
            plugins.notification.confirm = (message, callback, title, buttons) ->
                callback 1
        #  plugins.transitions = nativetransitions

        #  plugins.device = device
    )

    plugins
