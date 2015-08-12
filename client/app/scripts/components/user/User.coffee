m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
RoleVM = require '../auth/RoleVM'
DatePicker = require 'sm-datepicker'
Select2Helper = require '../util/Select2Helper'
InputHelper = require '../util/ui/InputHelper'

module.exports = class User extends Module

  constructor: (@app) ->
   
  @controller: () ->

    id = m.route.param("id") 
    VM.current.getForId id
    RoleVM.current.all()
    datePicker = new DatePicker({time: false})
    datePicker.masks =
#      "default": "ddd mmm dd yyyy HH:MM:ss",
      "default": "m/d/yy",
      shortDate: "m/d/yy",
      mediumDate: "mmm d, yyyy",
      longDate: "mmmm d, yyyy",
      fullDate: "dddd, mmmm d, yyyy",
      shortTime: "h:MM TT",
      mediumTime: "h:MM:ss TT",
      longTime: "h:MM:ss TT Z",
      isoDate: "yyyy-mm-dd",
      isoTime: "HH:MM:ss",
      isoDateTime: "yyyy-mm-dd'T'HH:MM:ss",
      isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
    datePicker: datePicker

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
        Module.msgError T9n.get firstMsg.error, firstMsg.params
      else
        VM.current.save()
        m.route VM.current.homeRoute
      false

#    selectData: for role in RoleVM.current.cache()
#      console.log 'selectData: ' + typeof role
#      role
    selectData: -> RoleVM.current.cache()
    changeRole: (ids) =>
#      console.log 'changeRole: ' + ids
      VM.current.attributes.rols ids
   
       
  @view: (ctrl) ->
    attr = VM.current.attributes
    console.log 'attr: ' + JSON.stringify attr
#    console.log 'allrols: ' + JSON.stringify RoleVM.current.cache()
#    console.log 'rols: ' + JSON.stringify attr.rols
    [
      H4(T9n.get 'User')
      FORM {class: 'pure-form pure-form-stacked'}, [
        @makeInput attr, 'nickname'
        @makeInput attr, 'email'
        @makeInput attr, 'firstname' 
        @makeInput attr, 'lastname'
        m 'label', {class: "clear"}, T9n.get 'Roles'
        m.component(Select2Helper, {data: ctrl.selectData(), values: attr.rols(), onchange: ctrl.changeRole}, {multiple: 'multiple', id: 'sel1'})
        LABEL {}, T9n.get 'birthday'
        INPUT {type: 'date', id: 'birthday', onchange: m.withAttr("value", attr['birthday']), value: attr['birthday']?() || null}, pickadate(this)
        LABEL {}, T9n.get 'password'
        INPUT {type: 'password', id: 'password', onchange: m.withAttr("value", attr['password']), value: attr['password']?() || null}
#        m('div', ctrl.datePicker.view())
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