var gulp = require('gulp'),
    gutil = require('gulp-util'),
    clean = require('gulp-clean'),
    sequence = require('run-sequence'),
    requireDir = require('require-dir'),
    yargs = require('yargs').argv;


requireDir('./gulp');

//var debug = yargs.debug ? yargs.debug : true;
//gutil.log('>> debug=' + debug);

gulp.task('clean', function () {
    return gulp.src(['www/css', 'www/js', 'www/img', 'assets/dist', 'assets/build'], {read: false})
        .pipe(clean({force: true}));
});

gulp.task('watch', function () {
    gulp.watch('assets/coffee/**/*.coffee', ['appjs']);
    gulp.watch('assets/scss/**/*.scss', ['css']);
    gulp.watch('assets/images/assets/*', ['image']);
    gulp.watch('assets/images/icons/*', ['sprite']);
});

gulp.task('assets', function () {
    sequence('css', 'image', 'javascript');
});

gulp.task('default', function () {
    sequence('clean', 'assets', 'watch');
});
