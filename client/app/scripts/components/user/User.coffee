m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
T9n = require '../util/T9n'

module.exports = class User extends Module

  constructor: (@app) ->

  @controller: () =>

    id = m.route.param("id")
    VM.current.getForId id

    back: () -> 
      m.route VM.current.homeRoute
      false

    save: () ->
      attr = VM.current.attributes
      msgs = VM.validate attr
      for m in msgs
        field = document.getElementById m.name
        field.className = 'error'
      if msgs.length
        Module.msgError msgs[0].msg
      else
        VM.current.save()
        m.route VM.current.homeRoute
      false
    

  @view: (ctrl) ->
    attr = VM.current.attributes
    [
      H4(T9n.get 'User')
      FORM {class: 'pure-form pure-form-stacked'}, [
        @makeInput attr, 'email'
        @makeInput attr, 'nickname'
        @makeInput attr, 'firstname' 
        @makeInput attr, 'lastname'
#        LABEL {}, T9n.get 'birthday'
#        INPUT {type: 'date', id: 'birthday', onchange: m.withAttr("value", attr['birthday']), value: attr['birthday']()}
        LABEL {}, T9n.get 'password'
        INPUT {type: 'password', id: 'password', onchange: m.withAttr("value", attr.password), value: attr.password()}
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