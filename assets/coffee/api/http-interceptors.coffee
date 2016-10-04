_ = require('lodash')
constants = require('../common/constants')

exports.apiInterceptor = ['$rootScope', '$log', '$q', ($rootScope, $log, $q) ->
    request: (config) ->
        ua = ionic.Platform.ua

#        check device is real in fake on dev mode only
        isRealDevice = ua.indexOf('SM-G900P') == -1

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
            # remark under code because Connection is undefined, i don't know why
#            if (navigator.connection and navigator.connection.type == Connection.NONE)
#                canceler.resolve('network.none')
#                $rootScope.$broadcast('network.none')

            token = window.localStorage.getItem('token')
            if token != null
                config.headers['token'] = token
            config || $q.when(config)

        return config
]