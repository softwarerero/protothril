m = require 'mithril'
Module = require '../abstract/Module'
VM = require './RoleVM'
T9n = require '../util/T9n'
TableHelper = require '../util/TableHelper'

module.exports = class Roles extends Module

  @controller: () =>
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
      H4(T9n.get 'Roles')
      DIV {id: 'roles'}, [
        FORM {class: 'pure-form'}, [
          INPUT {class: 'search', placeholder: 'Search', oninput: ctrl.tableHelper.filter}
        ]
        TABLE {class: 'pure-table'}, [
          THEAD [
            TR [
              TH(BUTTON {onclick: ctrl.add, class: 'pure-button pure-button-primary'}, T9n.get 'Add'),
              TH( {'data-sort-by': 'name', onclick: ctrl.tableHelper.sorts}, T9n.get 'name'),
            ]
          ]
          TBODY {class: 'list'}, [
            # hack because this is called sometimes when cache is resolved yet
#            if (typeof VM.current.cache()?.map) is 'function'
#              VM.current.cache()?.map (obj, index) ->
            for id, obj of VM.current.cache()                
              if not obj.filter
                TR {id: 'tableRow'}, [
                  TD [
                    BUTTON {onclick: m.withAttr('dataid', ctrl.delete), class: 'pure-button', dataid: obj.id}, T9n.get 'Remove'
                    SPAN ' '
                    BUTTON {onclick: m.withAttr('dataid', ctrl.edit), class: 'pure-button', dataid: obj.id}, T9n.get 'Edit'
                  ]
                  TD(obj.name, class: 'name'),
                ]
          ]
        ]
      ]
    ]

