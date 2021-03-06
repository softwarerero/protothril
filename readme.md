Protothril is the idea of a blueprint for web applications. It should include the tools I usually work with on the frontend and backend. It is very opinionated and temporary.
 
# Tools
## Frontend
* Gulp
* Mithril
* Less
* Purecss.io

## Backend
* node.js
* Express
* elasticsearch

# Features (√ means done)
* Ability to translate UI √
* Validation (in work)
* Crud lists with 
  * sorting √
  * filtering √
  * pagination √
* Easy form creation with helpers for 
  * select √
  * date √
  * number (InputHelper Mask Field) √
  * currency
  * boolean switch
  * captcha (https://github.com/emotionLoop/visualCaptcha)
  * file/image upload
* User Management
  * Registration √ 
  * Confirmation Email √
* Authentification √
* Role bases authorization
* Mobile App Ready (Cordova - http://blog.bitovi.com/getting-started-with-cordova-in-15-minutes-or-less/)
* Easy Deploy
* Modularization of server code

# V2 Features
* Datatransport with Messagepack
* Flexibilization of CSS (Purecss, Bootstrap, ...) with [transformers](http://lhorie.github.io/mithril-blog/when-css-lets-you-down.html)
* DDP over SSE
* image manipulation

### Ideas
* Alternative to private npm repos: http://fiznool.com/blog/2015/05/20/an-alternative-to-npm-private-modules/