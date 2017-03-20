#_ = require('lodash')
constants = require('../common/constants')

module.exports = ['$http', ($http) ->
    api = {
        login: (user, onSuccess, onError) ->
            $http.post('/api/tokens', user)
                .success(onSuccess)
                .error(onError)

        registerDeviceToken: (platform, uuid, token, onSuccess, onError) ->
            data =
                'deviceName': uuid,
                'deviceToken': token,
                'deviceType': platform

            $http.post('/api/device', data)
                .success(onSuccess)
                .error(onError)

        deleteDeviceToken: (token, onSuccess, onError) ->
            $http.delete("/api/device?deviceToken=#{token}")
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

        loadCourseExtend: (course_id, data, onSuccess, onError) ->
            qs = jQuery.param(data)
            $http.get("/api/courses/#{course_id}/extend?#{qs}")
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

        addToOrderCart: (shop_id, prodIdList, onSuccess, onError) ->
            courseList = prodIdList.join(',')
            data =
                'shopid': shop_id
                'courseList': courseList
            $http.post('/api/cart/order', data)
                .success(onSuccess)
                .error(onError)

        removeFromWish: (shop_id, prod_id, onSuccess, onError) ->
            $http({
                'url': "/api/cart/wish?shopid=#{shop_id}&courseList=#{prod_id}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        removeFromCart: (shop_id, prod_id, onSuccess, onError) ->
            $http({
                'url': "/api/cart/shop?shopid=#{shop_id}&courseList=#{prod_id}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        removeFromOrderCart: (shop_id, prod_id, onSuccess, onError) ->
            $http({
                'url': "/api/cart/order?shopid=#{shop_id}&courseList=#{prod_id}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        clearFromCart: (shop_id, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': ''
            $http.put('/api/cart/shop', data)
                .success(onSuccess)
                .error(onError)

        clearFromOrderCart: (shop_id, onSucess, onError) ->
            data =
                'shopid': shop_id
                'courseList': ''
            $http.put('/api/cart/order', data)
                .success(onSucess)
                .error(onError)

        updateCart: (shop_id, courseIdArray, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': _.join courseIdArray, ','
            $http.put('/api/cart/shop', data)
                .success(onSuccess)
                .error(onError)

        updateOrderCart: (shop_id, courseIdArray, onSuccess, onError) ->
            data =
                'shopid': shop_id
                'courseList': _.join courseIdArray, ','
            $http.put('/api/cart/order', data)
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

        getOrderCartList: (page, perpage, onSuccess, onError) ->
            $http.get("/api/cart/order?page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        createOrder: (shop_id, courses, payway, onSuccess, onError) ->
            data =
                'courses': courses
                'shopid': shop_id
                'payway': payway
            $http.post("/api/order", data)
                .success(onSuccess)
                .error(onError)

        getOrders: (status, page, perpage, onSuccess, onError) ->
            $http.get("/api/order?status=#{status}&page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        getCurrentEbooks: (onSuccess, onError) ->
            $http.get('/api/ebook/current')
                .success(onSuccess)
                .error(onError)

        getCatalogEbooks: (page, perpage, onSuccess, onError) ->
            $http.get("/api/ebook/catalogs?page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        getCatalogEbook: (yearmonth, catalog_id, onSuccess, onError) ->
            $http.get("/api/ebook/#{yearmonth}/#{catalog_id}")
                .success(onSuccess)
                .error(onError)

        getLocations: (onSuccess, onError) ->
            $http.get('/api/location')
                .success(onSuccess)
                .error(onError)

        getSurveys: (onSuccess, onError) ->
            $http.get('/api/queses')
                .success(onSuccess)
                .error(onError)

        getSurveyFill: (onSuccess, onError) ->
            $http.get('/api/queses/fillin')
                .success(onSuccess)
                .error(onError)

        getSurveyFillByCourse: (course_id, onSuccess, onError) ->
            $http.get("/api/queses/fillin?courseid=#{course_id}")
                .success(onSuccess)
                .error(onError)

        postSurveyFill: (data, onSuccess, onError) ->
            $http.post('/api/queses', data)
                .success(onSuccess)
                .error(onError)

        getMemberData: (onSuccess, onError) ->
            $http.get('/api/members')
                .success(onSuccess)
                .error(onError)

        updateMemberData: (data, onSuccess, onError) ->
            $http.put('/api/members', data)
                .success(onSuccess)
                .error(onError)

        getFinishCourses: (page, perpage, onSuccess, onError) ->
            $http.get("/api/studyCards/finish?page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        getMessageList: (page, perpage, type, onSuccess, onError) ->
            url = "/api/message?nowpage=#{page}&perpage=#{perpage}&type=#{type}"
            $http.get(url)
                .success(onSuccess)
                .error(onError)

        getMessage: (messageId, onSuccess, onError) ->
            $http.get("/api/message/#{messageId}")
                .success(onSuccess)
                .error(onError)

        sendValidPhone: (membid, onSuccess, onError) ->
            $http.get("/api/members/validphone?membid=#{membid}")
                .success(onSuccess)
                .error(onError)

        postPhoneValid: (data, onSuccess, onError) ->
            $http.post('/api/members/validphone', data)
                .success(onSuccess)
                .error(onError)

        registerMember: (data, onSuccess, onError) ->
            $http.post('/api/members', data)
                .success(onSuccess)
                .error(onError)

        forgotPassword: (para, onSuccess, onError) ->
            $http.get("/api/members/forgot?para=#{para}")
                .success(onSuccess)
                .error(onError)

        postSuggestion: (data, onSuccess, onError) ->
            $http.post('/api/suggest', data)
                .success(onSuccess)
                .error(onError)

        updatePassword: (old_password, new_password, onSuccess, onError) ->
            data =
                oldPW: old_password
                newPW: new_password
            $http.post('/api/members/password', data)
                .success(onSuccess)
                .error(onError)

        getUserSetting: (key, onSuccess, onError) ->
            $http.get("/api/usersetting/#{key}")
                .success(onSuccess)
                .error(onError)

        postUserSetting: (key, value, onSuccess, onError) ->
            $http.post("/api/usersetting/#{key}", value)
                .success(onSuccess)
                .error(onError)

        deleteUserSetting: (key, onSuccess, onError) ->
            $http({
                'url': "/api/usersetting/#{key}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        getMyFavoriteEbooks: (page, perpage, onSuccess, onError) ->
            $http.get("/api/ebook/my?page=#{page}&perpage=#{perpage}")
                .success(onSuccess)
                .error(onError)

        addEbookFavorite: (yearmonth, catalog_id, onSuccess, onError) ->
            data =
                yearmonth: yearmonth
                catalog: catalog_id
            $http.post('/api/ebook/my', data)
                .success(onSuccess)
                .error(onError)

        deleteFavoriteEbook: (yearmonth, catalog_id, onSuccess, onError) ->
            $http({
                'url': "/api/ebook/my?yearmonth=#{yearmonth}&catalog=#{catalog_id}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        getEbookIntro: (onSuccess, onError) ->
            $http.get('/api/ebook/intro')
                .success(onSuccess)
                .error(onError)

        postSocialLogin: (provider, token, onSuccess, onError) ->
            data =
                provider: provider
                accesstoken: token
                device: 'android'
            $http.post('/api/tokens/oauth', data)
                .success(onSuccess)
                .error(onError)

        cancelOrder: (order_no, onSuccess, onError) ->
            $http({
                'url': "/api/order/#{order_no}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        refundOrder: (order_no, onSuccess, onError) ->
            $http({
                'url': "/api/order/#{order_no}"
                'method': 'DELETE'
                'headers':
                    'Content-Type': 'application/json;charset=utf-8'
            }).then(onSuccess, onError)

        postImage: (key, image_in_base64, onSuccess, onError) ->
            data =
                'para': key
                'data': image_in_base64
            $http.post('/api/img', data)
                .success(onSuccess)
                .error(onError)

        getImageFromUrl: (url, onSuccess, onError) ->
            $http.get(url)
                .success(onSuccess)
                .error(onError)

        verifyPassword: (password, onSuccess, onError) ->
            $http.post('/api/members/password/ckeck', password)
                .success(onSuccess)
                .error(onError)

        postWishCard: (keyword, teacher, description, min, max, onSuccess, onError) ->
            data =
                course: keyword
                teacher: teacher
                require: description
                pay_min: min
                pay_max: max

            $http.post('/api/wish', data)
                .success(onSuccess)
                .error(onError)

        resendVerifyCode: (memberid, onSuccess, onError) ->
            $http.put('/api/members/validphone', '"' + memberid + '"')
                .success(onSuccess)
                .error(onError)

        # Payment (please always stay code below in bottom of this file)
        createATMPayment: (order_no, source_order_no, onSuccess, onError) ->
            api_url = constants.API_URL.atm
            data =
                'orderNo': order_no
                'sourceNo': source_order_no
            $http.post("#{api_url}/api/pay", data)
                .success(onSuccess)
                .error(onError)

        getATMPaymentInfo: (order_no, onSuccess, onError) ->
            api_url = constants.API_URL.atm
            data =
                'orderNo': order_no
            $http.post("#{api_url}/api/pay", data)
                .success(onSuccess)
                .error(onError)

        createCreditCardPayment: (order_no, source_order_no, card_no, expire, cvc, onSuccess, onError) ->
            api_url = constants.API_URL.creditcard
            data =
                'orderNo': order_no
                'cardNo': card_no
                'expire': expire
                'cvc': cvc
                'sourceNo': source_order_no
            $http.post("#{api_url}/api/pay", data)
                .success(onSuccess)
                .error(onError)
    }

]
