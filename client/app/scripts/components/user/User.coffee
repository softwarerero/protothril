m = require 'mithril'
jQuery = require 'jquery'
Select2Helper = require '../util/Select2Helper'
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
   
    selectData: [{id: '1', name: "John"}, {id: '2', name: "Mary"}, {id: '3', name: "Jane"}]
    changeUser: (id) =>
      VM.current.attributes.users id 
           

  @view: (ctrl) ->
    attr = VM.current.attributes
    [
      H4(T9n.get 'User')
      FORM {class: 'pure-form pure-form-stacked'}, [
        @makeInput attr, 'email'
        @makeInput attr, 'nickname'
        @makeInput attr, 'firstname' 
        @makeInput attr, 'lastname'
        LABEL {}, T9n.get 'birthday'
        INPUT {type: 'date', id: 'birthday', onchange: m.withAttr("value", attr['birthday']), value: attr['birthday']()}, pickadate(this)
        LABEL {}, T9n.get 'password'
        INPUT {type: 'password', id: 'password', onchange: m.withAttr("value", attr.password), value: attr.password()}
        m("label", "User")
        m.component(Select2Helper, {data: ctrl.selectData, values: attr.users, onchange: ctrl.changeUser}, {multiple: 'multiple', id: 'sel1'})
        BUTTON {onclick: ctrl.save, class: 'pure-button pure-button-primary'}, T9n.get "Save"
        SPAN ' '
        BUTTON {onclick: ctrl.back, class: 'pure-button'}, T9n.get "Back"
      ]
    ]
  
    
  pickadate = () ->
#    console.log  this 

 
#  extract: (xhr, xhrOptions) =>
#    if xhr.status is 401
#      @app.message.error xhr.responseText
#    else
#      @app.message.success 'Got users.'
#    xhr.response