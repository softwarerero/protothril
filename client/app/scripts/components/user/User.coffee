m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
T9n = require '../util/T9n'

module.exports = class User extends Module

  constructor: (@app) ->
    super(@app)

  @controller: () =>
    console.log @app
#    console.log 'controller.app: ' + JSON.stringify @conf.url

    back: () ->
      console.log 'back: ' + VM.current.homeRoute
      m.route VM.current.homeRoute

    save: () ->
#      console.log 'save'
      attr = VM.current.attributes
#      console.log 'attr: ' + JSON.stringify attr
      msgs = VM.validate attr
      if msgs.length
        console.log "error: " + msgs[0]
        Module.msgError msgs[0]
      else
        VM.current.save()
        m.route VM.current.homeRoute
      false
      
      
  @view: (ctrl) ->
    vm = VM.current
    attr = vm.attributes
    console.log 'email: ' + attr.email()
    [
      H4('User')
      FORM {class: 'pure-form pure-form-stacked'}, [
        LABEL {}, T9n.get 'Email'
        INPUT {id: 'email', onchange: m.withAttr("value", attr.email), value: attr.email()}
        LABEL {}, T9n.get 'Nickname'
        INPUT {onchange: m.withAttr("value", attr.nickname), value: attr.nickname()}
        LABEL {}, T9n.get 'Firstname'
        INPUT {onchange: m.withAttr("value", attr.firstname), value: attr.firstname()}
        LABEL {}, T9n.get 'Lastname'
        INPUT {onchange: m.withAttr("value", attr.lastname), value: attr.lastname()}
        LABEL {}, T9n.get 'Password'
        INPUT {type: 'password', onchange: m.withAttr("value", attr.password), value: attr.password()}
        BUTTON {onclick: ctrl.save, class: 'pure-button pure-button-primary'}, T9n.get "Save"
        SPAN ' '
        BUTTON {onclick: ctrl.back, class: 'pure-button'}, T9n.get "Back"
      ]
    ]

    
#  extract: (xhr, xhrOptions) =>
#    if xhr.status is 401
#      @app.message.error xhr.responseText
#    else
#      @app.message.success 'Got users.'
#    xhr.response