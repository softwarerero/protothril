m = require 'mithril'
Module = require '../abstract/Module'
VM = require './RightVM'
T9n = require '../../../../../shared/util/T9n'
TableHelper = require '../util/TableHelper'

module.exports = class Rights extends Module

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
      H4(T9n.get 'Rights')
      DIV {id: 'rights'}, [
        FORM {class: 'pure-form'}, [
          INPUT {class: 'search', placeholder: 'Search', oninput: ctrl.tableHelper.filter}
        ]
        TABLE {class: 'pure-table'}, [
          THEAD [
            TR [
              TH( I {class: 'fa fa-plus action th-action', onclick: m.withAttr('dataid', ctrl.add)} )
              TH( {'data-sort-by': 'name', onclick: ctrl.tableHelper.sorts}, T9n.get 'name'),
            ]
          ]
          TBODY {class: 'list'}, [
            for id, obj of VM.current.cache()
              if not obj.filter
                TR {id: 'tableRow'}, [
                  TD [
                    I {class: 'fa fa-pencil-square-o action', onclick: m.withAttr('dataid', ctrl.edit), dataid: obj.id}
                    SPAN ' '
                    I {class: 'fa fa-trash action', onclick: m.withAttr('dataid', ctrl.delete), dataid: obj.id}
                  ]
                  TD(obj.name, class: 'name'),
                ]
          ]
        ]
      ]
    ]

