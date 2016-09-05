var gulp = require('gulp'),
    gutil = require('gulp-util'),
    uglify = require('gulp-uglify'),
    browserify = require('gulp-browserify'),
    gif = require('gulp-if'),
    coffee = require('gulp-coffee'),
    sequence = require('run-sequence'),
    yargs = require('yargs').argv;


var debug = yargs.debug ? yargs.debug : true;

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
            debug: debug,
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
                'lodash': {
                    path: 'www/lib/lodash/dist/lodash.min.js',
                    exports: '_'
                },
                'moment': {
                    path: 'www/lib/moment/min/moment-with-locales.js',
                    exports: 'moment'
                }
            }
        }))
        .pipe(gif(!debug, uglify()))
        .pipe(gulp.dest('www/js'));
});

gulp.task('appjs', ['coffeeifyjs'], function () {
    return gulp.src('assets/build/coffeeify/js/**/main.js')
        .pipe(browserify({
            insertGlobals: false,
            debug: debug,
            external: ['jquery', 'angular', 'angular-translate', 'ionic', 'lodash', 'moment']
        }))
        .pipe(gif(!debug, uglify()))
        .pipe(gulp.dest('www/js'));
});