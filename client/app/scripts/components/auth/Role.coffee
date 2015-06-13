m = require 'mithril'
Module = require '../abstract/Module'
VM = require './RoleVM'
RightVM = require './RightVM'
T9n = require '../util/T9n'
Select2Helper = require '../util/Select2Helper'

module.exports = class Role extends Module

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

#    selectData: [{id: '1', name: "John"}, {id: '2', name: "Mary"}, {id: '3', name: "Jane"}]
#    selectData: RightVM.current.cache()
    selectData: for right in RightVM.current.cache()
      right.attributes
    changeRights: (ids) =>
      VM.current.attributes.rights ids

  @view: (ctrl) ->
    console.log 'ctrl.selectData: ' + JSON.stringify ctrl.selectData
    attr = VM.current.attributes
    [
      H4(T9n.get 'Role')
      FORM {class: 'pure-form pure-form-stacked'}, [
        @makeInput attr, 'name'
        m 'label', T9n.get 'Rights'
        m.component(Select2Helper, {data: ctrl.selectData, values: attr.rights, onchange: ctrl.changeRights}, {multiple: 'multiple', id: 'sel1'})
        BUTTON {onclick: ctrl.save, class: 'pure-button pure-button-primary'}, T9n.get "Save"
        SPAN ' '
        BUTTON {onclick: ctrl.back, class: 'pure-button'}, T9n.get "Back"
      ]
    ]

