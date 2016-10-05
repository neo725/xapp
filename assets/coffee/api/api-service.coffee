_ = require('lodash')
constants = require('../common/constants')

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

        clearFromCart: (shop_id, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': ''
            $http.put("/api/cart/shop", data)
                .success(onSuccess)
                .error(onError)

        getCourse: (shop_id, prod_id, onSuccess, onError) ->
            $http.get("/api/courses/#{prod_id}?shopid=#{shop_id}")
                .success(onSuccess)
                .error(onError)

        getUserCatalogs: (shop_id, onSuccess, onError) ->
            $http.get("/api/catalogs?shopid=#{shop_id}")
                .success(onSuccess)
                .error(onError)

        getAllCatalogs: (shop_id, onSuccess, onError) ->
            $http.get("/api/catalogs/all?shopid=#{shop_id}")
                .success(onSuccess)
                .error(onError)

        saveCatalogsSetting: (shop_id, catalogs, onSuccess, onError) ->
            data = {
                cataloglist: _.join(catalogs, ','),
                shopid: shop_id
            }
            $http.post('/api/catalogs', data)
                .success(onSuccess)
                .error(onError)

        getWishList: (page, perpage, onSuccess, onError) ->
            $http.get("/api/cart/wish?page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        getCartList: (page, perpage, onSuccess, onError) ->
            $http.get("/api/cart/shop?page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        createOrder: (shop_id, courses, onSuccess, onError) ->
            data =
                'courses': courses
                'shopid': shop_id
                'payway': 0
            $http.post("/api/order", data)
                .success(onSuccess)
                .error(onError)

        getOrders: (status, page, perpage, onSuccess, onError) ->
            $http.get("/api/order?status=#{status}&page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        # Payment (please always stay code below in bottom of this file)
        createATMPayment: (order_no, onSuccess, onError) ->
            api_url = constants.API_URL.atm
            data =
                'orderNo': order_no
            $http.post("#{api_url}/api/pay", data)
                .success(onSuccess)
                .error(onError)

        createCreditCardPayment: (order_no, card_no, expire, cvc, onSuccess, onError) ->
            api_url = constants.API_URL.creditcard
            data =
                'orderNo': order_no
                'cardNo': card_no
                'expire': expire
                'cvc': cvc
            $http.post("#{api_url}/api/pay", data)
                .success(onSuccess)
                .error(onError)
    }

]
