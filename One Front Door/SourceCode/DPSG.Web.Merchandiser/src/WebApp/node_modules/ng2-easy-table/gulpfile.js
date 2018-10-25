/*jshint esversion: 6 */
const gulp = require('gulp');
const del = require('del');
const typescript = require('gulp-typescript');
const tscConfig = require('./tsconfig.json');
const sass = require('gulp-sass');

// clean the contents of the distribution directory
gulp.task('clean', function () {
  return del('dist/**/*');
});

// TypeScript compile
gulp.task('compile:ts', ['clean'], function () {
  return gulp
    .src('app/**/*.ts')
    .pipe(typescript(tscConfig.compilerOptions))
    .pipe(gulp.dest('dist/app'));
});

// Styles compile
gulp.task('compile:scss', ['clean'], function () {
    return gulp
        .src('app/**/*.scss')
        .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
        .pipe(gulp.dest('app'));
});

gulp.task('copy:libs', ['clean'], function () {
  return gulp.src([
      'node_modules/es6-shim/es6-shim.min.js',
      'node_modules/zone.js/dist/zone.js',
      'node_modules/reflect-metadata/Reflect.js',
      'node_modules/systemjs/dist/system.src.js',
      'node_modules/rxjs/bundles/Rx.js'
    ])
    .pipe(gulp.dest('dist/lib'));
});

gulp.task('copy:assets', ['clean'], function () {
  return gulp
    .src('app/**/*.html')
    .pipe(gulp.dest('dist/app'));
});

gulp.task('copy:css', ['clean'], function () {
  return gulp.src('app/styles/*.css')
    .pipe(gulp.dest('dist/app/styles'));
});

gulp.task('build', [
    'compile:ts',
    'compile:scss',
    'copy:libs',
    'copy:assets',
    'copy:css'
]);

gulp.task('default', ['build']);