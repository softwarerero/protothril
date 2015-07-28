# Mithril + Coffee + Gulp + Browserify

This is a starter/example/seed repo I created for my own personal projects.

It includes:
  - [Mithril](http://lhorie.github.io/mithril/index.html)
  - [Browserify](http://browserify.org/)
  - [LESS](http://lesscss.org/)
  - [jQuery](http://jquery.com/)

## Gulp Tasks

- Run `gulp watch` to get local development started.
- Run `gulp build` to build a distribution.
- Run `gulp wiredep` to add new bower dependencies to your index.html.

### Intersting Reads
http://ratfactor.com/daves-guide-to-mithril-js?/mordor

### Authentification
https://auth0.com/blog/2014/01/07/angularjs-authentication-with-cookies-vs-token/

### Mithril
https://github.com/jsguy/mithril.sugartags - less verbose templating
https://libraries.io/search?q=mithril

### Depdendencies
* https://github.com/lydell/yaba - assert!
* npm install -g napa - needef for list.js
* https://libraries.io/bower/sm-datepicker, https://github.com/pinguxx/sm-datepicker

# CSS
http://nicolasgallagher.com/pure-css-speech-bubbles/demo/

### Date Picker
https://github.com/pinguxx/sm-datepicker
https://libraries.io/bower/sm-datepicker

## npm
### https://gist.github.com/coolaj86/1318304
### npm link - https://docs.npmjs.com/cli/link
npm link ../protothril-client

### Cordova
rich.k3r.me/blog/2015/04/02/controlling-cordova-from-gulp/
http://cordova.apache.org/docs/en/5.0.0/
cordova.apache.org/docs/en/5.0.0/guide_cli_index.md.html#The%20Command-Line%20Interface
cordova run --emulator android --target nexus-s # run emulator
cordova run android --device  #to deploy the app on a connected device

### Android
/usr/local/Cellar/android-sdk/22.6.2/bin/android sdk # manage sdk
/usr/local/Cellar/android-sdk/22.6.2/bin/android avd # configure target

### Jasmine Testing
https://jasmine.github.io/2.3/introduction.html
http://wallabyjs.com/ # Test Runner

### For a project that is build on this npm module issue first 
npm i browserify-shim caching-coffeeify connect connect-livereload serve-static serve-index cordova-lib del gulp gulp-autoprefixer gulp-cache gulp-coffee gulp-csso gulp-filter gulp-flatten gulp-imagemin gulp-jshint gulp-less gulp-livereload gulp-load-plugins gulp-notify gulp-run gulp-size gulp-sourcemaps gulp-uglify gulp-useref gulp-util jshint-stylish main-bower-files opn pretty-hrtime vinyl-source-stream watchify wiredep

### Idea: For destop apps
http://electron.atom.io/
