m = require 'mithril'
Module = require '../abstract/Module'

module.exports = class Login extends Module

  username = m.prop('john.doe')
  password = m.prop('foobar')
  loggedIn = m.prop(false)

  constructor: (@app) ->
    super(@app)
    
  controller: () ->
#    super
    login: () =>
      data = {username: username(), password: password()}
#      console.log JSON.stringify data
#      xhrConfig = (xhr) ->
#        xhr.setRequestHeader("withCredentials", "true")
#        xhr.withCredentials = true
#      request = {method: "POST", background: false, url: url, data: data, extract: extract, config: xhrConfig}
      url = Login.conf.url + 'login'
      request = {method: "POST", background: false, url: url, data: data, extract: extract}
      m.request(request).then(log) #.then(authorized)

  view: (ctrl) ->
    [
      m('p', loggedIn())
      m("input", {onchange: m.withAttr("value", username), value: username()})
      m('br')
      m("input", {type: 'password', onchange: m.withAttr("value", password), value: password()})
      m('br')
      m("button", {onclick: ctrl.login}, "Login")
    ]
    
    
  log = (xhr, err) ->
#    console.log 'log xhr: ' + JSON.stringify xhr
#    console.log('log err: ' + err)
    xhr

      
  extract = (xhr, xhrOptions) =>
    console.log 'xhr: ' + JSON.stringify xhr
#    console.log 'xhrOptions: ' + JSON.stringify xhrOptions
#    console.log 'status: ' + xhr.status
    
#    console.log 'responseText: ' + JSON.stringify xhr.responseText
    if xhr.status is 401
      delete window.sessionStorage.token
      @msgError xhr.responseText
      loggedIn false
      
    else if xhr.status > 200
#      delete window.sessionStorage.token
      @msgError 'Problem: ' + xhr.status
      loggedIn false
    else
#      console.log 'token: ' + JSON.parse(xhr.response).token
      window.sessionStorage.token = JSON.parse(xhr.response).token 
      @msgSuccess 'You are logged in successfully.'
      loggedIn true
      xhr.responseText
#    JSON.stringify xhr