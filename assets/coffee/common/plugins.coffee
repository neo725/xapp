module.exports = ->
    plugins = {
        statusBar: {isVisible: true, show: (->), hide: (->)}
        transitions: {flip: ->}
        camera: {getPicture: ->}
        cameraConstants: {
            DestinationType: {FILE_URI: 1},
            EncodingType: {PNG: 1},
            MediaType: {PICTURE: 0},
            PictureSourceType: {
                PHOTOLIBRARY: 0,
                CAMERA: 1,
                SAVEDPHOTOALBUM: 2
            }
        }
        device: {
            model: 'iPhone5,1'
        }
    }

    ionic.Platform.ready(->
        if window.plugins and StatusBar
            plugins.statusBar = StatusBar
        #  plugins.transitions = nativetransitions
        #  plugins.camera = navigator.camera
        #  plugins.cameraConstants = Camera
        #  plugins.device = device
    )

    plugins
