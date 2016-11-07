var gulp = require('gulp'),
    sass = require('gulp-sass'),
    spritesmith = require('gulp.spritesmith'),
    sequence = require('run-sequence'),
    rename = require('gulp-rename'),
    yargs = require('yargs').argv;


var debug = (yargs.debug == 'false') ? false : true;

gulp.task('image', function(){
    sequence(['image:assets', 'sprite']);
});

gulp.task('image:assets', function () {
    // fav icon
    /*gulp.src(['assets/images/favicon.ico']).pipe(gulp.dest('www/img'));*/

    return gulp.src('assets/images/assets/**/*')
        .pipe(gulp.dest('www/img'));
});

gulp.task('sprite', function () {
    var spriteData = gulp.src('assets/images/icons/**/*.png')
        .pipe(spritesmith({
            imgName: 'sprite.png',
            cssName: '_sprite.scss',
            imgPath: '../www/img/sprite.png',
            algorithm: 'top-down'
        }));

    spriteData.img.pipe(gulp.dest('www/img'));
    spriteData.css.pipe(gulp.dest('assets/scss/icon/'));
});

gulp.task('ic_notification', function() {
    gulp.src('./resources/android/ic_notification/**')
        .pipe(gulp.dest('./platforms/android/res'));
});