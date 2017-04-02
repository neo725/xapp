constants = require('../common/constants')

module.exports = ['$rootScope', '$log', '$translate', '$q', '$injector', 'plugins',
    ($rootScope, $log, $translate, $q, $injector, plugins) ->
        logApi = (logId, result, memo) ->
            $http = $injector.get('$http')
            data =
                logid: logId
                #result: result
                meno: memo
            $http.put('/api/log', data)

        return {
            response: (response) ->
                if response.config.requestTimestamp
                    currentTimestamp = new Date().getTime()
                    time = currentTimestamp - response.config.requestTimestamp
                    apiId = response.headers('apiid')
                    if apiId and time > 3000
                        $log.warn 'request over 3000 ms...'
                        logApi apiId, time.toString(), 'api-timeout'

                response || $q.when response

            responseError: (response) ->
                if response.config.requestTimestamp
                    currentTimestamp = new Date().getTime()
                    time = currentTimestamp - response.config.requestTimestamp
                    apiId = response.headers('apiid')
                    if apiId and time > 3000
                        $log.warn 'request over 3000 ms...'
                        logApi -1, time.toString(), 'api-timeout'

                if response.status >= 500
    #                $translate('errors.request_failed').then (text) ->
    #                    plugins.toast.show(text, 'long', 'top')
                    $translate(['errors.request_failed', 'popup.ok']).then (translator) ->
                        plugins.notification.confirm(
                            translator['errors.request_failed'],
                            (->),
                            '',
                            [translator['popup.ok']]
                        )
                if response.data and response.data['popout']
                    $translate(['popup.ok']).then (translator) ->
                        plugins.notification.confirm(
                            response.data['popout'],
                            (->),
                            '',
                            [translator['popup.ok']]
                        )

                $q.reject response

            request: (config) ->
                ua = ionic.Platform.ua

                #            check device is real in fake on dev mode only
                isRealDevice = ua.indexOf('SM-G900P') == -1
                isRealDevice &= ua.indexOf('Macintosh') == -1
                isRealDevice |= window.cordova

                isPayRequest = /(^http:|https:)\/\/[-a-zA-Z0-9:\/.]{2,100}\/api\/pay/gi.test(config.url)
                isApiRequest = isPayRequest or /^\/api\//.test(config.url)
                isLogRequest = isApiRequest and /^\/api\/log/.test(config.url)

                api_endpoint = "#{constants.API_URL.browser}"

                if isRealDevice
                    api_endpoint = "#{constants.API_URL.device}"

                if isApiRequest
                    if not isPayRequest
                        config.url = "#{api_endpoint}#{config.url}"
                    #canceler = $q.defer()
                    #config.timeout = canceler.promise
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

                    if not isLogRequest
                        config.requestTimestamp = new Date().getTime()

                    #config || $q.when(config)

                config || $q.when config
        }
]