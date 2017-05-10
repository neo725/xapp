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

exports.sceCheckboxValueAssign = ['$timeout', ($timeout) ->
    restrict: 'A'
    require: 'ngModel'
    scope:
        value: '=sceCheckboxValueAssign'
        checked: '=ngModel'
    link: (scope, elem, attrs) ->
        onChange = ->
            value = scope.value
            if not value
                scope.value = attrs.value
            else
                values = value.split(',')
                if scope.checked
                    values.push attrs.value
                    value = values.join(',')
                else
                    index = values.indexOf(attrs.value)
                    if index > -1
                        values.splice index, 1
                    if values.length == 0
                        value = undefined
                    else
                        value = values.join(',')
                scope.value = value
            scope.$apply()

        elem.bind('change', ->
            $timeout onChange
        )
]

exports.sceFormValidCount = ['$timeout',
    ($timeout) ->
        restrict: 'A'
        require: 'ngModel'
        scope:
            valid: '=ngValue'
            valid_list: '=ngModel'
            data_id: '=sceFormValidCount'
            list: '=sceFormValidCountList'
            this_id: '=sceFormValidCountThisId'
        link: (scope, elem, attrs) ->
            addToList = (list, item) ->
                index = list.indexOf(item)
                if index == -1
                    list.push item
                return list
            removeFromList = (list, item) ->
                index = list.indexOf(item)
                if index > -1
                    list.splice index, 1
                return list
            scope.$watch () ->
                    return scope.valid
                , () ->
                    checkValid = () ->
                        valid_list = []
                        if scope.valid_list
                            valid_list = scope.valid_list

                        list = scope.list
                        this_id = scope.this_id

                        item = _.find(list, { Topic_No: this_id })
                        if item
                            item.valid = scope.valid

                        valid = scope.valid
                        _.forEach(list, (item) ->
                            valid &= item.valid
                        )

                        if valid
                            valid_list = addToList(valid_list, scope.data_id)
                        else
                            valid_list = removeFromList(valid_list, scope.data_id)

                        scope.valid_list = valid_list
                        scope.$apply()
                    $timeout checkValid

]

exports.sceStringPad = ['$timeout', 'util', ($timeout, util) ->
    restrict: 'A'
    require: 'ngModel'
    scope:
        value: '=ngModel'
        padstring: '=sceStringPad'
        new_value: '=sceStringPadModel'
        length: '=sceStringPadLength'
    link: (scope, elem, attrs) ->
        updateValue = ->
            scope.new_value = util.pad(scope.value, scope.length, scope.padstring.toString())
            scope.$apply()

        scope.$watch 'value', ->
            $timeout updateValue
]

exports.sceFocus = ->
    restrict: 'A'
    link: (scope, elem, attrs) ->
        scope.$watch attrs.sceFocus, (value) ->
            if value
                elem[0].focus()

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
            if value > 0
                height = value + fit_size_append

                $(element).attr('style', "height: #{height}px !important")

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

exports.searchSlideFit = ['$window', '$timeout', '$log', ($window, $timeout, $log) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        plusHeight = 0
        if attrs.searchSlideFitIos
            plusHeight += parseInt(attrs.searchSlideFitIos)
        isIOS = ionic.Platform.isIOS()
        $element = $('.dashboard-pane-content')

        $tab = $('.tabs')
        $slider = $element.find('.search-slide-box')

        adjustHeight = () ->
            if $element.length == 0
                $timeout () ->
                    adjustHeight()
                , 1000
                return
            height = $window.innerHeight - ($element.position().top + $tab.outerHeight())

            if height < 0
                $timeout () ->
                    adjustHeight()
                , 500
            else
                height = 424 if height < 424
                $slider.css('height', height + 'px')

        adjustHeight()

        scope.$watch ->
                return $element.find('.guest-slides').length
            , (value) ->
                $log.info 'searchSlideFit >> watch >> value : ' + value
                if value == 0
                    $slider.css('height', '375px')
                    if isIOS and plusHeight > 0
                        $slider.css('height', $slider.outerHeight() + plusHeight + 'px')
                else
                    adjustHeight()
]

exports.sceCutHeight = ['$log', ($log) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
        height = element.height() - parseInt(attrs.sceCutHeight)
        element.height(height)
]

exports.sceRefresher = ['$log', '$ionicScrollDelegate',
    ($log, $ionicScrollDelegate) ->
        restrict: 'A'
        link: (scope, element, attrs) ->
            $log.info 'sceRefresher......'

            opacity_offset_min = 20
            opacity_offset_max = 80
            handler_drag_css = 'drag'
            handler_refresh_css = 'refresh'
            arrow_down_css = 'ion-arrow-down-c'
            arrow_up_css = 'ion-refresh'

            getPercentage = (input, min, max) ->
                return ((input - min) / (max - min))

            removeClass = ($obj, classes) ->
                for css in classes
                    $obj.removeClass(css)

            setIcon = ($icon, css, drag = true) ->
                removeClass($icon, [arrow_down_css, arrow_up_css])
                $icon.addClass(css)

                removeClass($icon, [handler_drag_css, handler_refresh_css])
                if drag
                    $icon.addClass(handler_drag_css)
                else
                    $icon.addClass(handler_refresh_css)

            $holder = $(attrs.sceRefresher)
            $handler = $holder.find('.handler')
            $icon = $handler.find('i')

            isTouchZone = false
            eventStart = false
            eventTouched = false
            startY = 0

            $element = $(element)
            $element.bind('touchstart', (e) ->
                $log.info 'refresher touchstart...'
                startY = e.originalEvent.touches[0].pageY
                top = $ionicScrollDelegate.getScrollPosition().top
                $log.info 'startY : ' + startY
                $log.info 'top : ' + top
                eventStart = false
                eventTouched = false
                isTouchZone = (startY < 130) and (top == 0)
                if isTouchZone
                    setIcon($icon, arrow_down_css, true)
                return true
            )
            $element.bind('touchmove', (e) ->
                offsetY = e.originalEvent.touches[0].pageY - startY
                if offsetY > 20
                    eventStart = true
                #$log.info 'offsetY : ' + offsetY
                #$log.info 'eventStart : ' + eventStart
                #$log.info 'isTouchZone : ' + isTouchZone

                if eventStart and isTouchZone
                    handlerOffsetY = if offsetY < 0 then 0 else offsetY
                    #handlerOffsetY = if handlerOffsetY > 100 then 100 else handlerOffsetY

                    opacity = getPercentage(handlerOffsetY, opacity_offset_min, opacity_offset_max)
                    opacity = if opacity < 0 then 0 else opacity
                    opacity = if opacity > 1 then 1 else opacity

                    eventTouched = (opacity == 1)
                    if opacity == 1
                        setIcon($icon, arrow_up_css, false)
                    else
                        setIcon($icon, arrow_down_css, true)
                    #$log.info 'handlerOffsetY : ' + handlerOffsetY
                    #$log.info 'opacity : ' + opacity

                    $handler.css({
                        'transform': 'translate(0, ' + handlerOffsetY + 'px)',
                        'opacity': opacity
                     })
                    return false
                return true
            )
            $element.bind('touchend', (e) ->
                $log.info 'refresher touchend...'
                eventStart = false
                $handler.css({
                    'transform': '',
                    'opacity': ''
                })
                setIcon($icon, arrow_down_css, true)
                if eventTouched
                    eventTouched = false
                    $log.info 'doRefresh()...'
                    scope.$eval(attrs.sceRefresherEvent)
            )
]