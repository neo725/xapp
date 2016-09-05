_ = require('lodash')

module.exports = ['$http', ($http) ->
    api = {
        login: (user, onSuccess, onError) ->
            $http.post('/api/tokens', user)
            .success(onSuccess)
            .error(onError)

        registerToken: (token, onSuccess, onError) ->
            data = {
                'deviceName': '',
                'deviceToken': token,
                'deviceType': 'android'
            }
            $http.post('/api/device', data)
                .success(onSuccess)
                .error(onError)

        logout: (token, onSuccess, onError) ->
            $http.delete("/api/tokens/#{token}")
            .success(onSuccess)
            .error(onError)

        getStudyCards: (onSuccess, onError) ->
            $http.get('/api/studyCards')
            .success(onSuccess)
            .error(onError)

        getCover: (onSuccess, onError) ->
            $http.get('/api/cover')
            .success(onSuccess)
            .error(onError)

        searchCourse: (data, onSuccess, onError) ->
            qs = jQuery.param(data)
            $http.get("/api/courses/search?#{qs}")
            .success(onSuccess)
            .error(onError)

    }

]
