m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
T9n = require '../util/T9n'

module.exports = class User extends Module

#  @vm = UserVM
  
  constructor: (@app) ->
#    super(UserVM)
#    @vm = UserVM

  @controller: () =>

    id = m.route.param("id")
    VM.current.getForId id

    back: () -> 
      console.log 'back: ' + VM.current.homeRoute
      m.route VM.current.homeRoute
      false

    save: () ->
      attr = VM.current.attributes
      msgs = VM.validate attr
      if msgs.length
        console.log "error: " + msgs[0]
        Module.msgError msgs[0]
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
        LABEL {}, T9n.get 'password'
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