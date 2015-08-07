m = require 'mithril'
Module = require '../abstract/Module'
T9n = require '../util/T9n'

module.exports = class Register extends Module

  @email = m.prop('')
  @password = m.prop('')

#  constructor: (@app) ->
#    super(@app)

  @controller: () =>
    register: () =>
      data = {email: Register.email(), password: Register.password()}
      url = Register.conf.url + 'register'
      console.log 'url: ' + url
      request = {method: "POST", background: false, url: url, data: data, extract: Register.extract}
      m.request request
      false

  @view: (ctrl) ->
    [
      m('h2', T9n.get 'Register')
      FORM {class: 'pure-form pure-form-stacked'}, [
        LABEL {}, T9n.get 'email'
        m("input", {onchange: m.withAttr("value", Register.email), value: Register.email()})
        LABEL {}, T9n.get 'password'
        m("input", {type: 'password', onchange: m.withAttr("value", Register.password), value: Register.password()})
        m("button", {class: 'pure-button', onclick: ctrl.register}, T9n.get 'Register')
      ]
    ]


  @extract: (xhr, xhrOptions) =>
    response = JSON.parse xhr.response
    console.log "response: " + JSON.stringify response
    if xhr.status > 200
#      console.log 'Problem: ' + xhr.status
      console.log 'Problem: ' + xhr.status + ' (' + response.error + ')'
      Module.msgError T9n.get response.error, response.params
    else
      console.log 'Good: ' + xhr.status
#      Register.msgSuccess T9n.get 'You are logged in successfully'
#      response: {"code":"registration.success","id":"rvAEvusCRxezAhfmo07ysw","obj":{"email":"test10@sun.com.py","password":"test123","apps":["prototype"],"isActive":false,"activationId":"88025550-da00-4820-98fa-ce351263178e"}}
      Module.msgError T9n.get response.msg
      m.route '/login'
    xhr.responseText

