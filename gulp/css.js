var gulp = require('gulp'),
    concat = require('gulp-concat'),
    sass = require('gulp-sass'),
    cleanCSS = require('gulp-clean-css'),
    gif = require('gulp-if'),
    rename = require('gulp-rename'),
    sequence = require('run-sequence'),
    sourcemaps = require('gulp-sourcemaps'),
    yargs = require('yargs').argv;


var debug = (yargs.debug == 'false') ? false : true;

gulp.task("css", function () {
    sequence("css:tocss", "css:minify");
});

gulp.task("css:tocss", function () {
    return gulp.src('assets/scss/**/*.scss')
        .pipe(sass())
        .pipe(rename(function (path) {
            path.extname = ".css";
        }))
        .pipe(gulp.dest('assets/build/css'));
});

gulp.task("css:minify", function () {
    return gulp.src('assets/build/css/*.css')
        //.pipe(sourcemaps.init())
        .pipe(gif(!debug, cleanCSS({compatibility: 'ie9'})))
        .pipe(rename(function (path) {
            if (!debug)
                path.basename += ".min";
            path.extname = ".css";
        }))
        .pipe(concat('site.css'))
        //.pipe(sourcemaps.write())
        .pipe(gulp.dest('www/css'));
});