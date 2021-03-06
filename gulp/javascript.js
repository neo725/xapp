var gulp = require('gulp'),
    gutil = require('gulp-util'),
    uglify = require('gulp-uglify'),
    browserify = require('gulp-browserify'),
    gif = require('gulp-if'),
    coffee = require('gulp-coffee'),
    sequence = require('run-sequence'),
    yargs = require('yargs').argv;


var debug = (yargs.debug == 'false') ? false : true;
gutil.log('>> javascript.debug=' + debug);

gulp.task('javascript', function(){
    sequence(['vendorjs', 'appjs']);
});

gulp.task('coffeeifyjs', function () {
    return gulp.src('assets/coffee/**/*.coffee')
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest('assets/build/coffeeify/js'))
});

gulp.task('vendorjs', ['coffeeifyjs'], function () {
    return gulp.src(['assets/build/coffeeify/js/vendor.js'])
        .pipe(browserify({
            insertGlobals: false,
            //debug: debug,
            debug: false,
            shim: {
                'jquery': {
                    path: 'www/lib/jquery/dist/jquery.js',
                    exports: '$'
                },
                'angular': {
                    path: 'www/lib/angular/angular.js',
                    exports: 'angular'
                },
                'angular-translate': {
                    path: 'www/lib/angular-translate/angular-translate.js',
                    exports: null,
                    depends: {
                        angular: 'angular'
                    }
                },
                'ionic': {
                    path: 'www/lib/ionic/js/ionic.bundle.js',
                    exports: 'ionic'
                },
                'ionic-angular': {
                    path: 'www/lib/ionic/js/ionic-angular.js',
                    exports: null,
                    depends: {
                        angular: 'angular',
                        ionic: 'ionic'
                    }
                },
                'ionic-native-transitions': {
                    path: 'node_modules/ionic-native-transitions/dist/ionic-native-transitions.js',
                    exports: null
                },
                'ion-affix': {
                    path: 'www/lib/ion-affix/ion-affix.js',
                    exports: null,
                    depends: {
                        angular: 'angular'
                    }
                },
                'lodash': {
                    path: 'www/lib/lodash/dist/lodash.min.js',
                    exports: '_'
                },
                'moment': {
                    path: 'www/lib/moment/min/moment-with-locales.js',
                    exports: 'moment'
                },
                'angular-svg-round-progressbar': {
                    path: 'www/lib/angular-svg-round-progressbar/build/roundProgress.js',
                    exports: null,
                    depends: {
                        angular: 'angular'
                    }
                },
                // 'ion.rangeSlider': {
                //    path: 'www/lib/ion.rangeSlider/js/ion.rangeSlider.js',
                //    exports: null,
                //    depends: {
                //        jquery: '$'
                //    }
                // },
                'jr-crop': {
                    path: 'www/lib/jr-crop/dist/jr-crop.js',
                    exports: null
                },
                'angular-cache': {
                    path: 'www/lib/angular-cache/dist/angular-cache.js',
                    exports: null,
                    depends: {
                        angular: 'angular'
                    }
                },
                'angular-action-sheet': {
                    path: 'node_modules/angular-action-sheet/angular-action-sheet.js',
                    exports: null,
                    depends: {
                        angular: 'angular'
                    }
                },
                'Sortable': {
                    path: 'www/lib/Sortable/Sortable.js',
                    exports: 'Sortable'
                },
                'PullToRefresh': {
                    path: 'node_modules/mobile-pull-to-refresh/dist/pullToRefresh.js',
                    exports: 'pullToRefresh'
                },
                'PullToRefreshAnimate': {
                    path: 'node_modules/mobile-pull-to-refresh/dist/styles/material2/animates.js',
                    exports: 'ptrAnimatesMaterial2'
                }
            }
        }))
        //.pipe(gif(!debug, uglify()))
        .pipe(uglify())
        .pipe(gulp.dest('www/js'));
});

gulp.task('appjs', ['coffeeifyjs'], function () {
    return gulp.src('assets/build/coffeeify/js/**/main.js')
        .pipe(browserify({
            insertGlobals: false,
            debug: debug,
            external: ['jquery', 'angular', 'angular-translate', 'ionic', 'ionic-native-transitions', 'ion-affix',
                /*'lodash', 'moment', 'angular-svg-round-progressbar', 'ion.rangeSlider', 'jr-crop', 'angular-cache',*/
                'lodash', 'moment', 'angular-svg-round-progressbar', 'jr-crop', 'angular-cache',
                'angular-action-sheet', 'Sortable', 'PullToRefresh', 'PullToRefreshAnimate']
        }))
        .pipe(gif(!debug, uglify({mangle: false})))
        .pipe(gulp.dest('www/js'));
});
