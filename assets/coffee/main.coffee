resources = require('./translation/index')()
httpInterceptors = require('./api/http-interceptors')
directives = require('./common/directives')
# filters = require('./common/filters')

# ngCordova install and setup
# http://ngcordova.com/docs/install/

angular.module('sce', ['ionic', 
    'ionic-native-transitions', 
    'ngCordova', 'ngCordovaOauth', 
    'pascalprecht.translate', 'ion-affix', 'jrCrop',
    'angular-svg-round-progressbar', 'angular-cache'])
.service('$cordovaLaunchNavigator', require('./common/launchnavigation-service'))
.service('navigation', require('./common/navigation-service'))
.service('util', require('./common/util-service'))
.factory('modal', require('./common/modal'))
.factory('plugins', require('./common/plugins'))
.factory('api', require('./api/api-service'))
.factory('apiInterceptor', require('./api/http-interceptors'))
.factory('creditcard', require('./common/creditcard-service'))
.factory('user', require('./common/user-service'))
.directive('goNative', directives.goNative)
.directive('ngNext', directives.ngNext)
.directive('customVerify', directives.customVerify)
.directive('starRating', directives.starRating)
.directive('messageDotMask', directives.messageDotMask)
.directive('fitSize', directives.fitSize)
.directive('searchSlideFit', directives.searchSlideFit)
.directive('sceCutHeight', directives.sceCutHeight)
.directive('sceCheckboxValueAssign', directives.sceCheckboxValueAssign)
.directive('sceFormValidCount', directives.sceFormValidCount)
.directive('sceStringPad', directives.sceStringPad)
.directive('sceFocus', directives.sceFocus)
.directive('sceRefresher', directives.sceRefresher)
.controller('IndexController', require('./controllers/index-controller'))
.controller('LoginController', require('./controllers/login-controller'))
.controller('MainController', require('./controllers/main-controller'))
.controller('ForgotPasswordController', require('./controllers/forgotpassword-controller'))
.controller('ResetPasswordController', require('./controllers/resetpassword-controller'))
.controller('RegisterController', require('./controllers/register-controller'))
.controller('PhoneConfirmController', require('./controllers/phoneconfirm-controller'))
.controller('EmailConfirmController', require('./controllers/emailconfirm-controller'))
.controller('ServiceRuleController', require('./controllers/service-rule-controller'))
.controller('PrivacyRuleController', require('./controllers/privacy-rule-controller'))
.controller('HomeController', require('./controllers/home-controller'))
.controller('DashboardController', require('./controllers/dashboard-controller'))
.controller('StudyCardSlideController', require('./controllers/dashboard-studycardslide-controller'))
.controller('SearchSlideController', require('./controllers/dashboard-searchslide-controller'))
.controller('DashboardCourseTimeController', require('./controllers/dashboard-course-time-controller'))
.controller('DashboardCourseLocationController', require('./controllers/dashboard-course-location-controller'))
.controller('DashboardWeekdayController', require('./controllers/dashboard-weekday-controller'))
.controller('DashboardLocationController', require('./controllers/dashboard-location-controller'))
.controller('DashboardFeedbackController', require('./controllers/dashboard-feedback-controller'))
.controller('MemberDashboardController', require('./controllers/member-dashboard-controller'))
.controller('MemberWishListController', require('./controllers/member-wish-list-controller'))
.controller('MemberOrderListController', require('./controllers/member-order-list-controller'))
.controller('MemberOrderInfoController', require('./controllers/member-order-info-controller'))
.controller('MemberFinishListController', require('./controllers/member-finish-list-controller'))
.controller('MemberCartListController', require('./controllers/member-cart-list-controller'))
.controller('MemberOrderCartListController', require('./controllers/member-order-cart-list-controller'))
.controller('MemberPaymentListController', require('./controllers/member-payment-list-controller'))
.controller('MemberMessageController', require('./controllers/member-message-controller'))
.controller('MemberMessageInfoController', require('./controllers/member-message-info-controller'))
.controller('MemberEditController', require('./controllers/member-edit-controller'))
.controller('MemberEditNameController', require('./controllers/member-edit-name-controller'))
.controller('MemberEditEmailController', require('./controllers/member-edit-email-controller'))
.controller('MemberEditIdentController', require('./controllers/member-edit-ident-controller'))
.controller('MemberEditPassword1Controller', require('./controllers/member-edit-pw-1-controller'))
.controller('MemberEditPassword2Controller', require('./controllers/member-edit-pw-2-controller'))
.controller('MemberEditMobileController', require('./controllers/member-edit-mobile-controller'))
.controller('MemberSuggestionController', require('./controllers/member-suggestion-controller'))
.controller('CourseSearchController', require('./controllers/course-search-controller'))
.controller('CourseInfoController', require('./controllers/course-info-controller'))
.controller('CourseCatalogsController', require('./controllers/course-catalogs-controller'))
.controller('CourseExtendController', require('./controllers/course-extend-controller'))
.controller('CourseSurveyController', require('./controllers/course-survey-controller'))
.controller('EbookListController', require('./controllers/ebook-list-controller'))
.controller('EbookInfoController', require('./controllers/ebook-info-controller'))
.controller('LocationController', require('./controllers/location-controller'))
.controller('LocationMapController', require('./controllers/location-map-controller'))
.run(require('./common/platform-ready'))
.run(require('./common/platform-exit'))
.run(require('./common/device-ready'))
.config(['$translateProvider', ($translateProvider) ->
    for language of resources
        $translateProvider.translations(language, resources[language])
])
.config(['$httpProvider', ($httpProvider) ->
    # $httpProvider.defaults.headers.common = {}
    # $httpProvider.defaults.headers.post = {}
    # $httpProvider.defaults.headers.put = {}
    # $httpProvider.defaults.headers.patch = {}

    $httpProvider.defaults.useXDomain = true
    delete $httpProvider.defaults.headers.common['X-Requested-With']

    $httpProvider.defaults.headers.patch =
        'Content-Type': 'application/json; charset=utf-8'

    #$httpProvider.interceptors.push(httpInterceptors.apiInterceptor)
    $httpProvider.interceptors.push('apiInterceptor')
])
.config(['$ionicConfigProvider', ($ionicConfigProvider) ->
    ## http://ionicframework.com/docs/api/provider/$ionicConfigProvider/
    #$ionicConfigProvider.views.maxCache(0)
    ## views.transition(transition)
    ## transition :
    ##      platform
    ##      android
    ##      ios
    ##      none
    $ionicConfigProvider.views.transition('none')
    #$ionicConfigProvider.views.transition('android')

    # http://scottbolinger.com/4-ways-to-make-your-ionic-app-feel-native/
    #$ionicConfigProvider.scrolling.jsScrolling(false)
    # updated by thchang @ 2018-10-15
    # https://timonweb.com/posts/improve-ionics-performance-in-android-with-native-scrolls/
    # only use native scroll in android
    if ionic.Platform.isAndroid()
        $ionicConfigProvider.scrolling.jsScrolling(false)

    # disable swipe effect
    $ionicConfigProvider.views.swipeBackEnabled(false)
])
.config(['$ionicNativeTransitionsProvider', ($ionicNativeTransitionsProvider) ->
    $ionicNativeTransitionsProvider.enable true
    #$ionicNativeTransitionsProvider.enable false

    options = {
        "direction"        : "left", # 'left|right|up|down', default 'left' (which is like 'next')
        "duration"         :  300,   # in milliseconds (ms), default 400
        "slowdownfactor"   :    3,   # overlap views (higher number is more) or no overlap (1). -1 doesn't slide at all. Default 4
        #"slidePixels"      :   20,   # optional, works nice with slowdownfactor -1 to create a 'material design'-like effect. Default not set so it slides the entire page.
        "iosdelay"         :  100,   # ms to wait for the iOS webview to update before animation kicks in, default 60
        "androiddelay"     :  100,   # same as above but for Android, default 70
        "winphonedelay"    :  250,   # same as above but for Windows Phone, default 200,
        "fixedPixelsTop"   :    0,   # the number of pixels of your fixed header, default 0 (iOS and Android)
        "fixedPixelsBottom":    0    # the number of pixels of your fixed footer (f.i. a tab bar), default 0 (iOS and Android)
    }

    $ionicNativeTransitionsProvider.setDefaultOptions options
])
.config(['CacheFactoryProvider', (CacheFactoryProvider) ->
    angular.extend(CacheFactoryProvider.defaults,
        storageMode: 'localStorage'
    )
])
.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->

    $stateProvider

    ## misc (before login)
    .state 'login',
        url: '/login'
        templateUrl: 'partial/login.html'

    ## main (before login)
    .state 'main',
        url: '/main'
        abstract: true
        templateUrl: 'partial/master/main.html'

    .state 'main.forgotpassword',
        url: '/forgotpassword'
        views: {
            'mainContent': {
                templateUrl: 'partial/forgotpassword.html'
            }
        }

    .state 'main.resetpassword',
        url: '/resetpassword'
        views: {
            'mainContent': {
                templateUrl: 'partial/resetpassword.html'
            }
        }

    .state 'main.register',
        url: '/register'
        views: {
            'mainContent': {
                templateUrl: 'partial/register.html'
            }
        }

    .state 'main.phoneconfirm',
        url: '/phoneconfirm'
        views: {
            'mainContent': {
                templateUrl: 'partial/phoneconfirm.html'
            }
        }

    .state 'main.emailconfirm',
        url: '/emailconfirm'
        views: {
            'mainContent': {
                templateUrl: 'partial/emailconfirm.html'
            }
        }

    .state 'main.service-rule',
        url: '/service-rule'
        views: {
            'mainContent': {
                templateUrl: 'partial/service-rule.html'
            }
        }

    .state 'main.privacy-rule',
        url: '/privacy-rule'
        views: {
            'mainContent': {
                templateUrl: 'partial/privacy-rule.html'
            }
        }

    ## home
    .state 'home',
        url: '/home'
        abstract: true
        templateUrl: 'partial/master/home.html'

    .state 'home.dashboard',
        url: '/dashboard'
        views: {
            'homeContent': {
                templateUrl: 'partial/dashboard.html'
            }
        }

    .state 'home.location',
        url: '/location'
        views: {
            'homeContent': {
                templateUrl: 'partial/location.html'
            }
        }

    .state 'home.location-map',
        url: '/location-map/:location'
        views: {
            'homeContent': {
                templateUrl: 'partial/location-map.html'
            }
        }

    .state 'home.course',
        url: '/course'
        abstract: true
        views: {
            'homeContent': {
                templateUrl: 'partial/course/index.html'
            }
        }

    .state 'home.course.search',
        url: '/search/:keyword'
        views: {
            'courseContent': {
                templateUrl: 'partial/course/search.html'
            }
        }

    .state 'home.course.info',
        url: '/info/:shop_id/:prod_id'
        views: {
            'courseContent': {
                templateUrl: 'partial/course/info.html'
            }
        }

    .state 'home.course.catalogs',
        url: '/catalogs'
        views: {
            'courseContent': {
                templateUrl: 'partial/course/catalogs.html'
            }
        }

    .state 'home.course.extend',
        url: '/extend/:course_id'
        views: {
            'courseContent': {
                templateUrl: 'partial/course/extend.html'
            }
        }

    .state 'home.course.survey',
        url: '/survey'
        views: {
            'courseContent': {
                templateUrl: 'partial/course/survey.html'
            }
        }

    ## Ebook
    .state 'home.ebook',
        url: '/ebook'
        abstract: true
        views: {
            'homeContent': {
                templateUrl: 'partial/ebook/index.html'
            }
        }

    .state 'home.ebook.list',
        url: '/list'
        views: {
            'bookContent': {
                templateUrl: 'partial/ebook/list.html'
            }
        }

    .state 'home.ebook.info',
        url: '/info/:yearmonth/:catalog_id'
        views: {
            'bookContent': {
                templateUrl: 'partial/ebook/info.html'
            }
        }

    ## Member
    .state 'home.member',
        url: '/member'
        abstract: true
        views: {
            'homeContent': {
                templateUrl: 'partial/member/index.html'
            }
        }

    .state 'home.member.dashboard',
        url: '/dashboard'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/dashboard.html'
            }
        }

    .state 'home.member.wish',
        url: '/wish'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/wish.html'
            }
        }

    .state 'home.member.order',
        url: '/order'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/order.html'
            }
        }

    .state 'home.member.order-info',
        url: '/order-info/:order_no'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/order-info.html'
            }
        }

    .state 'home.member.finish',
        url: '/finish'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/finish.html'
            }
        }

    .state 'home.member.message',
        url: '/message'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/message.html'
            }
        }

    .state 'home.member.message-info',
        url: '/message/:type/:group_id'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/message-info.html'
            }
        }

    .state 'home.member.payment-list',
        url: '/payment-list'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/payment-list.html'
            }
        }

    .state 'home.member.edit',
        url: '/edit'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit.html'
            }
        }

    .state 'home.member.edit-name',
        url: '/edit-name'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit-name.html'
            }
        }

    .state 'home.member.edit-email',
        url: '/edit-email'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit-email.html'
            }
        }

    .state 'home.member.edit-ident',
        url: '/edit-ident'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit-ident.html'
            }
        }

    .state 'home.member.edit-pw-1',
        url: '/edit-pw/1'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit-pw-1.html'
            }
        }

    .state 'home.member.edit-pw-2',
        url: '/edit-pw/2'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit-pw-2.html'
            }
        }

    .state 'home.member.edit-mobile',
        url: '/edit-mobile'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/edit-mobile.html'
            }
        }

    .state 'home.member.suggestion',
        url: '/suggestion'
        views: {
            'memberContent': {
                templateUrl: 'partial/member/suggestion.html'
            }
        }

    .state 'home.member.cart',
        url: '/cart'
        abstract: true
        views: {
            'memberContent': {
                templateUrl: 'partial/member/cart.html'
            }
        }

    .state 'home.member.cart.step1',
        url: '/1'
        views: {
            'cartContent': {
                templateUrl: 'partial/member/cart-1.html'
            }
        }

    .state 'home.member.cart.step2',
        url: '/2'
        views: {
            'cartContent': {
                templateUrl: 'partial/member/cart-2.html'
            }
        }

    .state 'home.member.cart.step3',
        url: '/3'
        views: {
            'cartContent': {
                templateUrl: 'partial/member/cart-3.html'
            }
        }

    .state 'home.member.order-cart',
        url: '/order-cart'
        abstract: true
        views: {
            'memberContent': {
                templateUrl: 'partial/member/order-cart.html'
            }
        }

    .state 'home.member.order-cart.step1',
        url: '/1'
        views: {
            'cartContent': {
                templateUrl: 'partial/member/order-cart-1.html'
            }
        }

    .state 'home.member.order-cart.step2',
        url: '/2'
        views: {
            'cartContent': {
                templateUrl: 'partial/member/order-cart-2.html'
            }
        }

    .state 'home.member.order-cart.step3',
        url: '/3'
        views: {
            'cartContent': {
                templateUrl: 'partial/member/order-cart-3.html'
            }
        }

    token = window.localStorage.getItem('token')

    if not token or token == null
        $urlRouterProvider.otherwise "/login"
    else
        $urlRouterProvider.otherwise '/home/dashboard'
])
