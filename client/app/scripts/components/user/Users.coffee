m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
assert = require("yaba")
T9n = require '../util/T9n'

module.exports = class Users extends Module

  @controller: () =>
    VM.current.all() # preload to hava data available in view

    add: () =>
      VM.current = new VM
      m.route("/user")

      
    edit: (id) =>
      user = VM.users().filter (u) ->
        u.attributes.id() is id
      if user
        VM.current.attributes = user[0].attributes
      assert VM.current instanceof VM 
      m.route("/user")

      
    delete: (id) =>
      VM.current.delete(id)


  @view: (ctrl) ->
    [
      H4(T9n.get 'Users')
      BUTTON {onclick: ctrl.add, class: 'pure-button pure-button-primary'}, T9n.get 'Add'
      TABLE {class: 'pure-table'}, [
        THEAD [
          TR(TH(''), TH(''), TH('Email'), TH('Apodo'))
        ]
        TBODY [
          VM.users().map (u, index) ->
            attr = u.attributes
            TR(
              TD(BUTTON {onclick: m.withAttr('dataid', ctrl.delete), class: 'pure-button', dataid: attr.id()}, T9n.get 'Remove'),
              TD(BUTTON {onclick: m.withAttr('dataid', ctrl.edit), class: 'pure-button', dataid: attr.id()}, T9n.get 'Edit'),
              TD(attr.email()), 
              TD(attr.nickname())
            )
        ]
      ]
    ]
#    m.redraw()
    
    
#  idAlert = (id) ->
#    console.log id
    
  extract: (xhr, xhrOptions) =>
    console.log 'extract'
#    console.log 'status: ' + xhr.status
#    console.log 'responseText: ' + xhr.responseText
    if xhr.status is 401
      @app.message.error xhr.responseText
    else
      @app.message.success 'Got users.'
    xhr.response