/*
  gulpfile.js
  ===========
  Rather than manage one giant configuration file responsible
  for creating multiple tasks, each task has been broken out into
  its own file in gulp/tasks. Any file in that folder gets automatically
  required by the loop in ./gulp/index.js (required below).

  To add a new task, simply add a new task file to gulp/tasks.
*/

require('./gulp');

var gulp = require('gulp')
del = require('del'),
  cordova = require('cordova-lib').cordova.raw;

var APP_PATH = './dist',
  CORDOVA_PATH = './cordova/www';

gulp.task('del-cordova', function(cb) {
  del([ CORDOVA_PATH + '/*' ], function() {
    cb();
  });
});

gulp.task('compile', [ 'del-cordova' ], function(cb) {
  return gulp.src([ APP_PATH + '/**/*' ])
    .pipe(gulp.dest(CORDOVA_PATH));
});

//gulp.task('build', [ 'compile' ], function(cb) {
//  process.chdir(__dirname + '/cordova');
//  cordova
//    .build()
//    .then(function() {
//      process.chdir('../');
//      cb();
//    });
//});

gulp.task('emulate', [ 'compile' ], function(cb) {
  process.chdir(__dirname + '/cordova');
  cordova
    .run({ platforms: [ 'ios' ] })
    .then(function() {
      process.chdir('../');
      cb();
    });
});
