require('angular')
require('ionic')
require('angular-translate')
require('ionic-native-transitions')
require('angular-svg-round-progressbar')


resources = require('./translation/index')()
httpInterceptors = require('./api/http-interceptors')
directives = require('./common/directives')
# filters = require('./common/filters')

# ngCordova install and setup
# http://ngcordova.com/docs/install/

angular.module('sce', ['ionic', 'ngCordova', 'pascalprecht.translate', 'ionic-native-transitions', 'angular-svg-round-progressbar'])
.service('navigation', require('./common/navigation-service'))
.factory('modal', require('./common/modal'))
.factory('plugins', require('./common/plugins'))
.factory('api', require('./api/api-service'))
.directive('goNative', directives.goNative)
.directive('ngNext', directives.ngNext)
.controller('IndexController', require('./controllers/index-controller'))
.controller('LoginController', require('./controllers/login-controller'))
.controller('MainController', require('./controllers/main-controller'))
.controller('ForgotPasswordController', require('./controllers/forgotpassword-controller'))
.controller('HomeController', require('./controllers/home-controller'))
.controller('DashboardController', require('./controllers/dashboard-controller'))
.controller('StudyCardSlideController', require('./controllers/dashboard-studycardslide-controller'))
.controller('SearchSlideController', require('./controllers/dashboard-searchslide-controller'))
.controller('DashboardWeekdayController', require('./controllers/dashboard-weekday-controller'))
.controller('DashboardLocationController', require('./controllers/dashboard-location-controller'))
.controller('MemberDashboardController', require('./controllers/member-dashboard-controller'))
.controller('MemberWishListController', require('./controllers/member-wish-list-controller'))
.controller('MemberOrderListController', require('./controllers/member-order-list-controller'))
.controller('MemberCartListController', require('./controllers/member-cart-list-controller'))
.controller('CourseSearchController', require('./controllers/course-search-controller'))
.controller('CourseInfoController', require('./controllers/course-info-controller'))
.controller('CourseCatalogsController', require('./controllers/course-catalogs-controller'))
.config(['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.useXDomain = true
    delete $httpProvider.defaults.headers.common['X-Requested-With']

    $httpProvider.defaults.headers.patch =
        'Content-Type': 'application/json; charset=utf-8'

    $httpProvider.interceptors.push(httpInterceptors.apiInterceptor)
])
.config(($stateProvider, $urlRouterProvider, $ionicConfigProvider, $ionicNativeTransitionsProvider) ->
    ## http://ionicframework.com/docs/api/provider/$ionicConfigProvider/
    ## views.transition(transition)
    ## transition :
    ##      platform
    ##      android
    ##      ios
    ##      none
    $ionicConfigProvider.views.transition('none')

    # http://scottbolinger.com/4-ways-to-make-your-ionic-app-feel-native/
    $ionicConfigProvider.scrolling.jsScrolling(false)

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

    $ionicNativeTransitionsProvider.enable true

    $urlRouterProvider.otherwise "/login"
)
.config(($translateProvider) ->
    for language of resources
        $translateProvider.translations(language, resources[language])
)
.run(require('./common/platform-ready'))