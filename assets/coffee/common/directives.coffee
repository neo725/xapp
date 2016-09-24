exports.goNative = ['$ionicGesture', '$ionicPlatform', '$log',
    ($ionicGesture, $ionicPlatform, $log) ->
        restrict: 'A'
        link: (scope, element, attrs) ->
            $log.info 'goNative'
            #$ionicGesture.on 'tap', () ->
            $ionicGesture.on 'tap', (e) ->
                direction = attrs.direction
                transitionType = attrs.transitionType

                fakeTransition =
                    slide: ->
                    flip: ->
                    fade: ->
                    drawer: ->
                    curl: ->

                nativepagetransitions = fakeTransition
                if window.plugins
                    window.plugins.nativepagetransitions

                $ionicPlatform.ready () ->
                    switch transitionType
                        when 'slide'
                            nativepagetransitions.slide
                                'direction': direction
                            , (->), (->)
                        when 'flip'
                            nativepagetransitions.flip
                                'direction': direction
                            , (->), (->)
                        when 'fade'
                            nativepagetransitions.fade {}
                            , (->), (->)
                        when 'drawer'
                            nativepagetransitions.drawer
                                'origin': direction
                                'action': 'open'
                            , (->), (->)
                        when 'curl'
                            nativepagetransitions.curl
                                'direction': direction
                            , (->), (->)
                        else
                            nativepagetransitions.slide
                                'direction': direction
                            , (->), (->)
            , element
]

exports.ngNext = ['$timeout',
    ($timeout) ->
        restrict: 'A'
        link: (scope, elem, attrs) ->
            nextLength = parseInt(attrs.ngNextLength)
            scope.$watch(attrs.ngModel, (value) ->
                if value == undefined
                    return
                value = value.toString()
                if value.length == nextLength
                    $timeout(->
                        $("input[name='#{attrs.ngNext}']").focus()
                    )
            )
]