m = require 'mithril'
Module = require '../abstract/Module'

module.exports = class ConfirmRegistration extends Module

  @controller: () =>
#    console.log 'ConfirmRegistration'
    email = m.route.param 'email'
    console.log 'email: ' + email
    token = m.route.param 'token'
    console.log 'token: ' + token
    data = {email: email, token: token}
    url = Module.conf.url + 'confirmRegistration'
    console.log 'url: ' + url
    request = {method: "POST", background: false, url: url, data: data, extract: ConfirmRegistration.extract}
    m.request request

  @view: (ctrl) ->
    [
      m 'h2', 'hi'
#      m('h2', T9n.get 'ConfirmRegistration')
#      FORM {class: 'pure-form pure-form-stacked'}, [
#        LABEL {}, T9n.get 'email'
#        m("input", {onchange: m.withAttr("value", Register.email), value: Register.email()})
#        LABEL {}, T9n.get 'password'
#        m("input", {type: 'password', onchange: m.withAttr("value", Register.password), value: Register.password()})
#        m("button", {class: 'pure-button', onclick: ctrl.register}, T9n.get 'Register')
#      ]
    ]


  @extract: (xhr, xhrOptions) =>
    response = JSON.parse xhr.response
    if xhr.status > 200
#      console.log 'Problem: ' + xhr.status
      console.log 'Problem: ' + xhr.status + ' (' + response.error + ')'
      Module.msgError T9n.get response.error, response.params
    else
#      console.log 'Good: ' + xhr.status
#      Register.msgSuccess T9n.get 'You are logged in successfully'
      Module.msgError T9n.get response.msg
      m.route '/login'
    xhr.responseText

