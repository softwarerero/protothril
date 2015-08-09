m = require 'mithril'
Module = require '../abstract/Module'
VM = require './RoleVM'
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
        theads = -> [
          TH( {'data-sort-by': 'name', onclick: ctrl.tableHelper.sorts}, T9n.get 'name'),
        ]
        tdata = (obj) -> [
          TD(obj.name, class: 'name'),
        ]
        ctrl.tableHelper.makeTable(ctrl, VM.current.cache(), theads, tdata)
      ]
    ]

