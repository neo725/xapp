module.exports = ->
    plugins = {
        statusBar: {isVisible: true, show: (->), hide: (->)}
        transitions: {flip: ->}

        device:
            model: 'iPhone5,1'
        toast:
            'show': (->)
    }

    ionic.Platform.ready(->
        if window.plugins

            if StatusBar
                plugins.statusBar = StatusBar

            plugins.toast = window.plugins.toast


        #  plugins.transitions = nativetransitions

        #  plugins.device = device
    )

    plugins
