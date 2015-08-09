m = require 'mithril'
Module = require '../abstract/Module'
UserVM = require '../user/UserVM'
RoleVM = require '../auth/RoleVM'
RightVM = require '../auth/RightVM'

module.exports = class Login extends Module

  @loggedIn: -> !!window.sessionStorage.token
  @username: -> window.sessionStorage.username
  @email = m.prop('test12@sun.com.py')
  @password = m.prop('test123')
  @profile = null

#  constructor: (@app) ->
#    super(@app) 
    
  @controller: () ->
    login: () ->
      data = {email: Login.email(), password: Login.password()}
      url = Login.conf.url + 'login'
      console.log 'url: ' + url
      request = {method: "POST", background: false, url: url, data: data, extract: Login.extract}
      m.request(request).then(@log) #.then(authorized)
      false

  @view: (ctrl) ->
    [ 
      m('h2', T9n.get 'Login')
      FORM {class: 'pure-form pure-form-stacked'}, [
        LABEL {}, T9n.get 'email'
        m("input", {onchange: m.withAttr("value", Login.email), value: Login.email()})
        LABEL {}, T9n.get 'password'
        m("input", {type: 'password', onchange: m.withAttr("value", Login.password), value: Login.password()})
        m("button", {class: 'pure-button', onclick: ctrl.login}, T9n.get 'Login')
      ]
      if window.App.conf.register
        [
          m('br')
          m 'a[href="/register"]', {config: m.route, class: 'pure-menu-link2'}, T9n.get 'offerRegistration'
        ]
    ]
    
    
  @log = (xhr, err) ->
    xhr

      
  @extract: (xhr, xhrOptions) =>
    console.log 'xhr.status: ' + JSON.stringify xhr.status
    console.log 'xhr.response: ' + JSON.stringify xhr.response
    console.log 'xhrOptions: ' + JSON.stringify xhrOptions
    if xhr.status is 401
      delete window.sessionStorage.token
      delete window.sessionStorage.username
      Login.msgError xhr.responseText
      Login.loggedIn false
      Login.profile = null
    if xhr.status is 400
      response = JSON.parse xhr.response
      Login.msgError T9n.get response.error
    else if xhr.status > 200
      delete window.sessionStorage.token
      delete window.sessionStorage.username
      Login.msgError 'Problem: ' + xhr.status
      Login.loggedIn false
      Login.profile = null
    else
      response = JSON.parse xhr.response
      console.log 'response: ' + JSON.stringify response
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
    