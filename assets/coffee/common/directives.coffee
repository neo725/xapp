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
            autofill = attrs.ngNextAutofill
            autofill_length = attrs.ngNextAutofillLength

            scope.$watch(attrs.ngModel, (value) ->
                if value == undefined
                    return
                value = value.toString()

                pad = ''

                if autofill_length
                    autofill_length = parseInt(autofill_length)
                    pad += autofill for i in [0...autofill_length]

                    if value.length < autofill_length
                        value = pad.substring(0, pad.length - value.length) + value

                if value.length == nextLength
                    $timeout(->
                        $("input[name='#{attrs.ngNext}']").focus()
                    )
            )
]

exports.customVerify = () ->
    require: 'ngModel'
    scope:
        customVerify: '='
    link: (scope, elem, attrs, ctrl) ->
        scope.$watch () ->
            if scope.customVerify or ctrl.$viewValue
                combined = scope.customVerify + '_' + ctrl.$viewValue
            return combined
        , (value) ->
            if value
                ctrl.$parsers.unshift (viewValue) ->
                    origin = scope.customVerify
                    if origin != viewValue
                        ctrl.$setValidity("customVerify", false)
                        return undefined
                    else
                        ctrl.$setValidity("customVerify", true)
                        return viewValue

exports.toggleVisible = ->
    restrict: 'A'
    link: (scope, elem, attrs) ->
        front = attrs.toggleVisible
        rear = attrs.toggleVisibleRear

        front_ctrl = $(elem).find('.' + front)
        rear_ctrl = $(elem).find('.' + rear)

        front_ctrl.show()
        rear_ctrl.hide()

        elem.bind('click', ->
            visible = scope.visible
            if visible is undefined
                visible = false

            if visible
                front_ctrl.show()
                rear_ctrl.hide()
            else
                front_ctrl.hide()
                rear_ctrl.show()

            scope.visible = !visible
        )
