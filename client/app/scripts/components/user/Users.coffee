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
#              TH(BUTTON {onclick: ctrl.add, class: 'pure-button pure-button-primary'}, T9n.get 'Add'),
              TH( I {class: 'fa fa-plus action th-action', onclick: m.withAttr('dataid', ctrl.add)} )
              TH( {'data-sort-by': 'email', onclick: ctrl.tableHelper.sorts}, T9n.get 'email')
              TH( {'data-sort-by': 'nickname', onclick: ctrl.tableHelper.sorts}, T9n.get 'nickname')
            ]
          ]
          TBODY {class: 'list'}, [
            # hack because this is called sometimes when cache is resolved yet
#            console.log JSON.stringify VM.current.cache()
#            console.log 'users2: ' + JSON.stringify VM.current.cache()
#            console.log 'typeof: ' + typeof VM.current.cache()
            for id, obj of VM.current.cache()
              console.log 'users.obj: ' + JSON.stringify obj
#              console.log JSON.stringify obj
#            if (typeof VM.current.cache()?.map) is 'function'
#              console.log 'users: ' + JSON.stringify VM.current.cache()
#              VM.current.cache()?.map (obj, index) ->
              if not obj.filter
                TR {id: 'tableRow'}, [
                  TD [
                    I {class: 'fa fa-pencil-square-o action', onclick: m.withAttr('dataid', ctrl.edit), dataid: obj.id}
                    SPAN ' '
                    I {class: 'fa fa-trash action', onclick: m.withAttr('dataid', ctrl.delete), dataid: obj.id}
                  ]
                  TD(obj.email, class: 'email'),
                  TD(obj.nickname, class: 'nickname')
                ]
          ]
        ]
      ]
    ]


