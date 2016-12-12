module.exports = ['$q', ($q) ->
    $cordovaLaunchNavigator = {}

    $cordovaLaunchNavigator.navigate = (destination, options) ->
        q = $q.defer()
        isRealDevice = ionic.Platform.isWebView()
        if !isRealDevice
            q.reject 'launchnavigator will only work on a real mobile device! It is a NATIVE app launcher.'
        else
            try
                successFn = options.successCallBack or ->
                errorFn = options.errorCallback or ->

                _successFn = ->
                    successFn()
                    q.resolve()
                    return

                _errorFn = (err) ->
                    errorFn err
                    q.reject err
                    return

                options.successCallBack = _successFn
                options.errorCallback = _errorFn
                launchnavigator.navigate destination, options
            catch e
                q.reject 'Exception: ' + e.message
        q.promise
    
    return $cordovaLaunchNavigator
]