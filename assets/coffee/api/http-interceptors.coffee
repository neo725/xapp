#_ = require('lodash')
constants = require('../common/constants')

exports.apiInterceptor = ['$rootScope', '$log', '$translate', '$q', 'plugins',
    ($rootScope, $log, $translate, $q, plugins) ->
        response: (response) ->
            #$log.debug "success with status #{response.status}"
            response || $q.when response

        responseError: (rejection) ->
            if rejection.status >= 500
#                $translate('errors.request_failed').then (text) ->
#                    plugins.toast.show(text, 'long', 'top')
                $translate(['errors.request_failed', 'popup.ok']).then (translator) ->
                    plugins.notification.confirm(
                        translator['errors.request_failed'],
                        (->),
                        '',
                        [translator['popup.ok']]
                    )
            if rejection.data and rejection.data['popout']
                $translate(['popup.ok']).then (translator) ->
                    plugins.notification.confirm(
                        rejection.data['popout'],
                        (->),
                        '',
                        [translator['popup.ok']]
                    )

            $q.reject rejection

        request: (config) ->
            ua = ionic.Platform.ua

#            check device is real in fake on dev mode only
            isRealDevice = ua.indexOf('SM-G900P') == -1
            isRealDevice &= ua.indexOf('Macintosh') == -1

            isPayRequest = /(^http:|https:)\/\/[-a-zA-Z0-9\/.]{2,100}\/api\/pay/gi.test(config.url)
            isApiRequest = isPayRequest or /^\/api\//.test(config.url)

            api_endpoint = "#{constants.API_URL.browser}"

            if isRealDevice
                api_endpoint = "#{constants.API_URL.device}"

            if isApiRequest
                if not isPayRequest
                    config.url = "#{api_endpoint}#{config.url}"
                canceler = $q.defer()
                config.timeout = canceler.promise
#                # remark under code because Connection is undefined, i don't know why
#                if (navigator.connection and navigator.connection.type == Connection.NONE)
#                    canceler.resolve('network.none')
#                    $rootScope.$broadcast('network.none')

                token = window.localStorage.getItem('token')
                if token != null
                    config.headers['token'] = token
                token = window.sessionStorage.getItem('token')
                if token != null
                    config.headers['token'] = token

                config || $q.when(config)

            return config
]