m = require 'mithril'
Module = require '../abstract/Module'
VM = require './RightVM'

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
      validation = VM.validate attr
      if validation.isInvalid()
        firstMsg = validation.msgs[0]
        field = document.getElementById firstMsg.name
        field.className = 'error'
        Module.msgError @T9n.get firstMsg.error, firstMsg.params
      else
        VM.current.save()
        m.route VM.current.homeRoute
      false


  @view: (ctrl) ->
    attr = VM.current.attributes
    [
      H4(@T9n.get 'Right')
      FORM {class: 'pure-form pure-form-stacked'}, [
        @makeInput attr, 'name'
        BUTTON {onclick: ctrl.save, class: 'pure-button pure-button-primary'}, @T9n.get "Save"
        SPAN ' '
        BUTTON {onclick: ctrl.back, class: 'pure-button'}, @T9n.get "Back"
      ]
    ]

