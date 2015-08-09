m = require 'mithril'
# need to require shared moduls once somewhere
require '../../../shared/util/T9n'
require '../../../shared/util/Validation'

# Main namespace
window.App = app = {} 
window.App.conf = app.conf = conf = require './conf'
menu = require './components/Menu'
app.message = message = require './components/Message'
login = require './components/auth/Login'
logout = require './components/auth/Logout' 
users = require './components/user/Users'
user = require './components/user/User'
confirmRegistration = require './components/auth/ConfirmRegistration'
rights = require './components/auth/Rights'
right = require './components/auth/Right'
roles = require './components/auth/Roles'
role = require './components/auth/Role'
register = require './components/auth/Register'

m.module(document.getElementById("message"), {controller: message.controller, view: message.view})
m.module(document.getElementById("menu"), {controller: menu.controller, view: menu.view})

m.route document.getElementById("my-content"), "/users", 
  "/login": login
  "/logout": logout
  "/users": users
  "/user": user
  "/user/:id": user
  "/rights": rights
  "/right": right
  "/right/:id": right
  "/roles": roles
  "/role": role
  "/role/:id": role
  "/register": register
#  http://127.0.0.1:3017/confirmRegistration/test@sun.com.py/75e97deb-0d06-4509-874f-eed3495dcc51
  "/confirmRegistration/:email/:token": confirmRegistration


if not T9n.isDefined 't9nLanguage'
  require './components/util/T9n/en'
  require './components/util/T9n/es'
  #  T9n.map "en", require '../auth/auth.en'
  require './components/auth/auth.es'
  #  T9n.map "en", require '../user/user.en'
  require './components/user/user.es'
  T9n.setLanguage 'es'



#process.on 'uncaughtException', (err) ->
#  log.critical('uncaught', err)
#  log err.message
#  log err.stack
#  setTimeout () ->
#    // cleanup and exit...
#  , 1000