_ = require('lodash')

module.exports = ['$http', ($http) ->
    api = {
        login: (user, onSuccess, onError) ->
            $http.post('/api/tokens', user)
            .success(onSuccess)
            .error(onError)

        registerToken: (uuid, token, onSuccess, onError) ->
            data =
                'deviceName': uuid,
                'deviceToken': token,
                'deviceType': 'android'

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

        addToWish: (shop_id, prod_id, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': prod_id
            $http.post('/api/cart/wish', data)
                .success(onSuccess)
                .error(onError)

        addToCart: (shop_id, prod_id, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': prod_id
            $http.post('/api/cart/shop', data)
                .success(onSuccess)
                .error(onError)

        removeFromWish: (shop_id, prod_id, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': prod_id
            $http({
                'url': '/api/cart/wish'
                'method': 'DELETE'
                'data': data
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        removeFromCart: (shop_id, prod_id, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': prod_id
            $http({
                'url': '/api/cart/shop'
                'method': 'DELETE'
                'data': data
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        getCourse: (shop_id, prod_id, onSuccess, onError) ->
            $http.get("/api/courses/#{prod_id}?shopid=#{shop_id}")
                .success(onSuccess)
                .error(onError)

        getAllCatalogs: (shop_id, onSuccess, onError) ->
            $http.get("/api/catalogs/all?shopid=#{shop_id}")
                .success(onSuccess)
                .error(onError)
    }

]
