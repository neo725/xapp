module.exports = ['$state', '$timeout', '$ionicNativeTransitions', ($state, $timeout, $ionicNativeTransitions) ->
    goSlide =
        (view, data, direction) ->
#            console.log $ionicNativeTransitions
            options =
                'direction': direction
            $ionicNativeTransitions.stateGo view, data, {}, options
#            $timeout(
#                $state.go view, data
#            )
#
#            if window.plugins
#                options =
#                    'direction': direction
#                window.plugins.nativepagetransitions.slide options

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
