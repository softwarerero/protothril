m = require 'mithril'

# Component Classes
# Main namespace
window.App = app = {} 
window.App.conf = app.conf = conf = require './conf'
menu = require './components/Menu'
app.message = message = require './components/Message'
login = new (require './components/auth/Login')(app)
users = require './components/user/Users'
user = require './components/user/User'
rights = require './components/auth/Rights'
right = require './components/auth/Right'
roles = require './components/auth/Roles'
role = require './components/auth/Role'


m.module(document.getElementById("menu"), {controller: menu.controller, view: menu.view})
m.module(document.getElementById("message"), {controller: message.controller, view: message.view})


m.route document.getElementById("my-content"), "/users", 
#  "/": todo,
  "/login": login,
  "/users": users,
  "/user": user,
  "/user/:id": user,
  "/rights": rights,
  "/right": right,
  "/right/:id": right,
  "/roles": roles,
  "/role": role,
  "/role/:id": role,



#$ document
#  .ready ->
#    m.module $('#my-content')[0], app

#process.on 'uncaughtException', (err) ->
#  log.critical('uncaught', err)
#  log err.message
#  log err.stack
#  setTimeout () ->
#    // cleanup and exit...
#  , 1000