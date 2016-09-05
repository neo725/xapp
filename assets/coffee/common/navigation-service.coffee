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

    return {
        slide: goSlide
        flip: goFlip
    }
]
