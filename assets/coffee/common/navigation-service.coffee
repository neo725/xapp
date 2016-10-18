module.exports = ['$state', '$timeout', ($state, $timeout) ->
    goSlide =
        (view, data, direction) ->
            $timeout(
                $state.go view, data
            )

            if window.plugins
                options =
                    'direction': direction
                window.plugins.nativepagetransitions.slide options

    goFlip =
        (view, data, direction) ->
            $timeout(->
                $state.go view, data
            )

            if window.plugins
                options =
                    'direction': direction
                window.plugins.nativepagetransitions.flip options

    return {
        slide: goSlide
        flip: goFlip
    }
]
