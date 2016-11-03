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
                if value.indexOf('undefined') > -1
                    ctrl.$setValidity("customVerify", false)
                    return undefined
                underline_pos = value.indexOf('_')
                if (underline_pos == 0 or underline_pos == value.length - 1)
                    ctrl.$setValidity("customVerify", false)
                    return undefined
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

exports.messageDotMask = ->
    restrict: 'A'
    link: (scope, element, attrs) ->

        findParentCtrl = (jqElement, className) ->
            tagName = jqElement.prop("tagName")
            if jqElement.hasClass(className)
                return jqElement
            if tagName == 'BODY'
                return undefined
            parentCtrl = jqElement.parent()

            return findParentCtrl(parentCtrl, className)

        messageCtrl = findParentCtrl($(element), attrs.messageDotMask)

        if messageCtrl
            $(element).height(messageCtrl.height() - 39)

exports.fitSize = ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        fit_size = attrs.fitSize
        fit_size_append = attrs.fitSizeAppend || 0

        if fit_size_append
            fit_size_append = parseInt(fit_size_append)

        targetElement = $(element).find(fit_size)

        scope.$watch () ->
            height = targetElement.outerHeight()
            return height
        , (value) ->
            console.log 'watch : ' + value
            if value > 0
                height = value + fit_size_append

                $(element).attr('style', "height: #{height}px !important")

exports.customPopOver = ['$timeout', ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        $element = $(element)
        custom_pop_over = parseInt(attrs.customPopOver)
        custom_pop_over_width = attrs.customPopOverWidth

        $element.width(custom_pop_over_width)

        scope.$watch () ->
            return $element.position().top
        , (value) ->
            previousTop = $element.data('set-top')

            if value > 0 and previousTop != value
                $timeout(
                    value += custom_pop_over
                    $element.data('set-top', value)
                    $element.css({'top': value + 'px'})
                , 500)
]
exports.starRating = ->
    restrict: 'A'
    template: '<ul class="star-rating" ng-class="{readonly: readonly}">' +
              '  <li ng-repeat="star in stars" class="star" ng-class="{filled: star.filled}" ng-click="toggle($index)">' +
              '    <i class="ion-android-star"></i>' +
              '  </li>' +
              '</ul>'
    require: '?ngModel'
    scope:
        ratingValue: '=ngModel'
        max: '=?'
        onRatingSelect: '&?'
        readonly: '=?'
    link: (scope, element, attrs, ngModel) ->
        if scope.max == undefined
            scope.max = 5
        updateStars = ->
            scope.stars = []
            i = 0
            while i < scope.max
                scope.stars.push filled: i < scope.ratingValue
                i++
            return
        scope.toggle = (index) ->
            if scope.readonly == undefined || scope.readonly == false
                scope.ratingValue = index + 1
                scope.onRatingSelect {
                    rating: index + 1
                }
        scope.$watch 'ratingValue', (oldValue, newValue) ->
            newValue = newValue ? newValue : 0
            if newValue >= 0
                updateStars()