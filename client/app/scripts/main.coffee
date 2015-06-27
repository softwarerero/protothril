m = require 'mithril'

# Main namespace
window.App = app = {} 
window.App.conf = app.conf = conf = require './conf'
menu = require './components/Menu'
app.message = message = require './components/Message'
login = new (require './components/auth/Login')(app)
logout = require './components/auth/Logout' 
users = require './components/user/Users'
user = require './components/user/User'
rights = require './components/auth/Rights'
right = require './components/auth/Right'
roles = require './components/auth/Roles'
role = require './components/auth/Role'

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



#process.on 'uncaughtException', (err) ->
#  log.critical('uncaught', err)
#  log err.message
#  log err.stack
#  setTimeout () ->
#    // cleanup and exit...
#  , 1000