module.exports = ['$state', ($state) ->
    goSlide =
        (view, data, direction) ->
            $state.go view, data
            if window.plugins
                window.plugins.nativepagetransitions.slide
                    'direction': direction

    goFlip =
        (view, data, direction) ->
            $state.go view, data
            if window.plugins
                window.plugins.nativepagetransitions.flip
                    'direction': direction

    goCurl =
        (view, data, direction) ->
            $state.go view, data
            if window.plugins
                window.plugins.nativapagetransitions.curl
                    'direction': direction

    return {
        slide: goSlide
        flip: goFlip
        curl: goCurl
    }
]
