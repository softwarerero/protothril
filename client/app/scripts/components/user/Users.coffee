m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
assert = require("yaba")
TableHelper = require '../util/TableHelper'

module.exports = class Users extends Module

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

    first: () ->
      VM.current.from = 0
      VM.current.all()
    previous: () ->
      if VM.current.from >= VM.current.pageSize
        VM.current.from = VM.current.from - VM.current.pageSize
        VM.current.all()
    next: () ->
      if VM.current.from < VM.current.total - VM.current.pageSize
        VM.current.from = VM.current.from + VM.current.pageSize
        VM.current.all()
    last: () ->
      rest = VM.current.total % VM.current.pageSize
      VM.current.from = VM.current.total - rest
      VM.current.all()


  @view: (ctrl) ->
    [
      H4(T9n.get 'Users')
      DIV {id: 'users'}, [
        theads = -> [
          TH( {'data-sort-by': 'email', onclick: ctrl.tableHelper.sorts}, T9n.get 'email')
          TH( {'data-sort-by': 'nickname', onclick: ctrl.tableHelper.sorts}, T9n.get 'nickname')
        ]
        tdata = (obj) -> [
          TD(obj.email, class: 'email'),
          TD(obj.nickname, class: 'nickname')
        ]
        ctrl.tableHelper.makeTable(ctrl, VM.current.cache(), theads, tdata)
      ]
    ]

    
