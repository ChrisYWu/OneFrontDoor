/* global require, module */

var Angular2App = require('angular-cli/lib/broccoli/angular2-app');

module.exports = function(defaults) {
    return new Angular2App(defaults, {

        vendorNpmFiles: [
          'systemjs/dist/system-polyfills.js',
          'systemjs/dist/system.src.js',
          'zone.js/dist/*.js',
          'es6-shim/es6-shim.js',
          'core-js/client/core.min.js',
          'reflect-metadata/*.js',
          'rxjs/**/*.js',
          '@angular/**/*.js',
          'ng2-bootstrap/**/*.js',
          'bootstrap/dist/**/*',
          'bootstrap-sass/assets/**/*',
          'moment/moment.js',
          'angular2-modal/**/*.js',
          'ng2-dnd/**/*.js',
          'ng2-dnd/**/*.css',
          'ng2-easy-table/**/*.js',
          'ng2-easy-table/**/*.css',
          'ng2-datepicker/**/*.js',
          'ng2-auto-complete/**/*.js',
          'ng2-map/**/*.js',         
          'ng2-webstorage/**/*.js',
          'ng2-idle/**/*.js'
        ],
        sassCompiler: {
   
            includePaths: ['src/contents/scss']
            
        },

    }
     ) ;
};
