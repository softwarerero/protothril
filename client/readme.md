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

### Depdendencies
* https://github.com/lydell/yaba - assert!
* npm install -g napa - needef for list.js

# CSS
http://nicolasgallagher.com/pure-css-speech-bubbles/demo/

## npm
### npm link - https://docs.npmjs.com/cli/link
npm link ../protothril-client

### Cordova
rich.k3r.me/blog/2015/04/02/controlling-cordova-from-gulp/
http://cordova.apache.org/docs/en/5.0.0/
cordova run --emulator android --target nexus-s # run emulator
cordova run android --device  #to deploy the app on a connected device

### Android
/usr/local/Cellar/android-sdk/22.6.2/bin/android sdk # manage sdk
/usr/local/Cellar/android-sdk/22.6.2/bin/android avd # configure target

### Jasmine Testing
https://jasmine.github.io/2.3/introduction.html