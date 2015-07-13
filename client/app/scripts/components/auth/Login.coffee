m = require 'mithril'
Module = require '../abstract/Module'
T9n = require '../util/T9n'
UserVM = require '../user/UserVM'
RoleVM = require '../auth/RoleVM'
RightVM = require '../auth/RightVM'

module.exports = class Login extends Module

  @loggedIn: -> !!window.sessionStorage.token
  @username: -> window.sessionStorage.username
  email = m.prop('2121@1.cc')
  password = m.prop('123')
  @profile = null

  constructor: (@app) ->
    super(@app) 
    
  controller: () =>
    login: () =>
      data = {email: email(), password: password()}
      url = Login.conf.url + 'login'
      request = {method: "POST", background: false, url: url, data: data, extract: @extract}
      m.request(request).then(log) #.then(authorized)

  view: (ctrl) ->
    [ 
      m("input", {onchange: m.withAttr("value", email), value: email()})
      m('br')
      m("input", {type: 'password', onchange: m.withAttr("value", password), value: password()})
      m('br')
      m("button", {class: 'pure-button', onclick: ctrl.login}, "Login")
    ]
    
    
  log = (xhr, err) ->
#    console.log 'log xhr: ' + JSON.stringify xhr 
#    console.log('log err: ' + err)  
    xhr

      
  extract: (xhr, xhrOptions) =>
#    console.log 'xhr: ' + JSON.stringify xhr
#    console.log 'xhrOptions: ' + JSON.stringify xhrOptions

    if xhr.status is 401
      delete window.sessionStorage.token
      delete window.sessionStorage.username
      Login.msgError xhr.responseText
      Login.loggedIn false
      Login.profile = null
    else if xhr.status > 200
      delete window.sessionStorage.token
      delete window.sessionStorage.username
      Login.msgError 'Problem: ' + xhr.status
      Login.loggedIn false
      Login.profile = null
    else
      response = JSON.parse(xhr.response)
      window.sessionStorage.token = response.token
      window.sessionStorage.username = response.profile.nickname || response.profile.email
      Login.profile = response.profile
      
      Login.msgSuccess T9n.get 'You are logged in successfully'
      Login.loggedIn true
      m.route @app.conf.defaultRoute

      # preload to hava data available in view
      RoleVM.current.all (roles) ->
        RightVM.current.all (rights) ->
          console.log 'hasRole: ' + Login.hasRole 'sdfd'
          console.log 'hasRole: ' + Login.hasRole 'nix'
          console.log 'hasRight: ' + Login.hasRight 'nix'
          console.log 'hasRight: ' + Login.hasRight 'b444'

      xhr.responseText

      
  @hasRole: (name) ->
    role = RoleVM.current.forName name
    if role?.id 
#      console.log 'profile: ' + JSON.stringify Login.profile
#      roles = Login.profile.rols
      return !!(r for r in Login.profile.rols when r is role?.id)
    return false

  @hasRight: (name) ->
    rights = RightVM.current.forName name
    if rights?.id
      roles = Login.profile.rols
      for roleId in roles
        role = RoleVM.current.cache()[roleId]
        for rightId in role.rights
          if rightId is rights.id
            return true
    return false  
    