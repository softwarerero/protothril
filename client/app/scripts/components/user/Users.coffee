m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
assert = require("yaba")
T9n = require '../util/T9n'
TableHelper = require '../util/TableHelper'

module.exports = class Users extends Module

  @controller: () =>
#    VM.current.all() # preload to hava data available in view
    tableHelper: new TableHelper VM.current

    add: () =>
      VM.current = VM.current.createObj()
      m.route "/#{VM.current.verb}"   

    edit: (id) => 
      m.route("/#{VM.current.verb}/#{id}")

    delete: (id) =>
      VM.current.delete id
      m.redraw()



  @view: (ctrl) ->
    [
      H4(T9n.get 'Users')
      DIV {id: 'users'}, [
        FORM {class: 'pure-form'}, [
          INPUT {class: 'search', placeholder: 'Search', oninput: ctrl.tableHelper.filter}
        ]
        TABLE {class: 'pure-table pure-table-striped'}, [
          THEAD [
            TR [
              TH(BUTTON {onclick: ctrl.add, class: 'pure-button pure-button-primary'}, T9n.get 'Add'),
              TH( {'data-sort-by': 'email', onclick: ctrl.tableHelper.sorts}, T9n.get 'email'),
              TH( {'data-sort-by': 'nickname', onclick: ctrl.tableHelper.sorts}, T9n.get 'nickname')
            ]
          ]
          TBODY {class: 'list'}, [
            # hack because this is called sometimes when cache is resolved yet
            if (typeof VM.current.cache()?.map) is 'function'
              VM.current.cache()?.map (u, index) ->
                attr = u.attributes
                if not u.filter
                  TR {id: 'tableRow'}, [
                    TD [
                      BUTTON {onclick: m.withAttr('dataid', ctrl.delete), class: 'pure-button', dataid: attr.id()}, T9n.get 'Remove'
                      SPAN ' ' 
                      BUTTON {onclick: m.withAttr('dataid', ctrl.edit), class: 'pure-button', dataid: attr.id()}, T9n.get 'Edit'
                    ]
                    TD(attr.email(), class: 'email'),
                    TD(attr.nickname(), class: 'nickname')
                  ]
          ]
        ]
      ]
    ]


