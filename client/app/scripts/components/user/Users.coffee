m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
assert = require("yaba")
T9n = require '../util/T9n'

module.exports = class Users extends Module

  @controller: () =>
    VM.current.all() # preload to hava data available in view

    add: () =>
      VM.current = VM.current.createObj()
      m.route("/user")
      
    edit: (id) =>
      console.log 'verb: ' + @verb
      m.route("/user/#{id}")
      
    delete: (id) =>
      VM.current.delete id
      m.redraw()


  @view: (ctrl) ->
    [
      H4(T9n.get 'Users')
      BUTTON {onclick: ctrl.add, class: 'pure-button pure-button-primary'}, T9n.get 'Add'
      TABLE {class: 'pure-table'}, [
        THEAD [
          TR(TH(''), TH(''), TH(T9n.get 'email'), TH(T9n.get 'nickname'))
        ]
        TBODY [
          VM.current.cache()?.map (u, index) ->
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
    
    
#  extract: (xhr, xhrOptions) =>
#    console.log 'extract'
#    if xhr.status is 401
#      @app.message.error xhr.responseText
#    else
#      @app.message.success 'Got users.'
#    xhr.response