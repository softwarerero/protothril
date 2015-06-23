m = require 'mithril'
Module = require '../abstract/Module'
T9n = require '../util/T9n'
RoleVM = require '../auth/RoleVM'
UserVM = require '../user/UserVM'

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
      m("button", {onclick: ctrl.login}, "Login")
    ]
    
    
  log = (xhr, err) ->
#    console.log 'log xhr: ' + JSON.stringify xhr 
#    console.log('log err: ' + err)  
    xhr

      
  extract: (xhr, xhrOptions) =>
    console.log 'xhr: ' + JSON.stringify xhr
    console.log 'xhrOptions: ' + JSON.stringify xhrOptions

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
      console.log 'profile: ' + JSON.stringify response.profile
      window.sessionStorage.username = response.profile.nickname || response.profile.email
      Login.profile = response.profile
      Login.hasRole 'sdfd'
      
      Login.msgSuccess T9n.get 'You are logged in successfully'
      Login.loggedIn true
      xhr.responseText

      
  @hasRole: (name) ->
    roles = RoleVM.current.cache()
    console.log 'name: ' + JSON.stringify name
    console.log 'roles: ' + JSON.stringify roles
    idForName = null
    for role in roles
      console.log 'attributes: ' + JSON.stringify role.attributes
      console.log 'name: ' + JSON.stringify role.attributes.name
      console.log 'is: ' + (role.attributes.name() is name)
      if role.attributes.name() is name
        idForName = role.attributes.id()
    console.log 'idForName: ' + idForName
    if idForName
      users = UserVM.current.cache()
      console.log 'users: ' + JSON.stringify users
    idForName is true