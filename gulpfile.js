/* jshint node: true */
'use strict';
require('coffee-script/register');

var
  gulp = require('gulp'),
  jasmine = require('gulp-jasmine'),
  reporters = require('jasmine-reporters'),
  coffee = require('gulp-coffee'),
  nodemon = require('gulp-nodemon'),
  exit = require('gulp-exit');

gulp.task('jasm', function(){
  return gulp.src('src/**/*Spec.{js,coffee}')
    .pipe(jasmine({
      reporter: new reporters.TerminalReporter()
    }))
    .pipe(exit());
});

gulp.task('watchtest', function(){
  gulp.watch([
    'test/**/*Spec.{js,coffee}',
    'src/**/*.{js,coffee}'
], ['jasm']);
});

gulp.task('watch', function(){
  gulp.watch([
    'test/**/*Spec.{js,coffee}',
    'src/**/*.{js,coffee}'
], ['coffee']);
});

gulp.task('coffee', function() {
  gulp.src('./coffee/**/*.coffee')
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest('./public/scripts/'));
});

gulp.task('start', function () {
  nodemon({
    script: 'index.js'
  , env: { 'NODE_ENV': 'development' }
  })
})

gulp.task('test', ['jasm']);

gulp.task('default', ['coffee', 'start','watch']);
