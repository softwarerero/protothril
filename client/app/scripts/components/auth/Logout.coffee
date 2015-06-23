m = require 'mithril'
Module = require '../abstract/Module'
Login = require './Login'
Message = require '../Message'
T9n = require '../util/T9n' 

module.exports = class Logout  #extends Module

  @controller: () -> 
    delete window.sessionStorage.token
    delete window.sessionStorage.username
    Message.success T9n.get 'You are logged out successfully'
    Login.loggedIn false
    m.route '/login'

  @view: (ctrl) -> 
#    p 'no' 


#  logout: ->
#    console.log 'logout'
#    delete window.sessionStorage.token
#    @msgSuccess 'You are logged out successfully.'
#    loggedIn false
    