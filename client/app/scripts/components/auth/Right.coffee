m = require 'mithril'
Module = require '../abstract/Module'
VM = require './RightVM'
T9n = require '../util/T9n'

module.exports = class Right extends Module

  constructor: (@app) ->

  @controller: () =>

    id = m.route.param("id")
    VM.current.getForId id 

    back: () ->
      m.route VM.current.homeRoute
      false

    save: () ->
      attr = VM.current.attributes
#      console.log 'attr: ' + JSON.stringify attr   
      msgs = VM.validate attr
#      console.log 'msgs: ' + msgs 
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
      H4(T9n.get 'Right')
      FORM {class: 'pure-form pure-form-stacked'}, [
        @makeInput attr, 'name'
        BUTTON {onclick: ctrl.save, class: 'pure-button pure-button-primary'}, T9n.get "Save"
        SPAN ' '
        BUTTON {onclick: ctrl.back, class: 'pure-button'}, T9n.get "Back"
      ]
    ]

