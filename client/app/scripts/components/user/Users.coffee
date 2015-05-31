m = require 'mithril'
Module = require '../abstract/Module'
VM = require './UserVM'
assert = require("yaba")
T9n = require '../util/T9n'

module.exports = class Users extends Module

  @controller: () =>
    VM.current.all() # preload to hava data available in view
    copy = VM.current.all()

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
      DIV {id: 'users'}, [
        FORM {class: 'pure-form'}, [
          INPUT {class: 'search', placeholder: 'Search', oninput: filter}
        ]
        TABLE {class: 'pure-table'}, [
          THEAD [
            TR [
              TH(BUTTON {onclick: ctrl.add, class: 'pure-button pure-button-primary'}, T9n.get 'Add'),
              TH(''),
              TH( {'data-sort-by': 'email', onclick: sorts}, T9n.get 'email'),
              TH( {'data-sort-by': 'nickname', onclick: sorts}, T9n.get 'nickname')
            ]
          ]
          TBODY {class: 'list'}, [
            VM.current.cache()?.map (u, index) ->
              attr = u.attributes
              if not attr.filter()
                TR {id: 'tableRow'}, [
                  TD(BUTTON {onclick: m.withAttr('dataid', ctrl.delete), class: 'pure-button', dataid: attr.id()}, T9n.get 'Remove'),
                  TD(BUTTON {onclick: m.withAttr('dataid', ctrl.edit), class: 'pure-button', dataid: attr.id()}, T9n.get 'Edit'),
                  TD(attr.email(), class: 'email'),
                  TD(attr.nickname(), class: 'nickname')
                ]
          ]
        ]
      ]
    ]


  sorts = (e) ->
    prop = e.target.getAttribute("data-sort-by")
    list = VM.current.cache()
    if prop
      first = list[0]
      list.sort (a, b) ->
        return a.attributes[prop]() > b.attributes[prop]() ? 1 : a.attributes[prop]() < b.attributes[prop]() ? -1 : 0
      for n in e.target.parentNode.childNodes
        n.className = ''
      if (first is list[0])
        e.target.className = 'desc'
        list.reverse()
      else
        e.target.className = 'asc'


  filter = (e) ->
    search = document.getElementsByClassName('search')[0].value
    m.startComputation()
    VM.current.cache()?.map (o, index) ->
      found = true
      for key, value of o.attributes
        if key isnt 'filter' and key isnt 'id'
#          console.log "value: " + value() + ' = ' + search + ': ' + value()?.indexOf(search)
          if value()?.indexOf(search) > -1
            found = false
      o.attributes.filter found
      m.endComputation()



#  extract: (xhr, xhrOptions) =>
#    console.log 'extract'
#    if xhr.status is 401
#      @app.message.error xhr.responseText
#    else
#      @app.message.success 'Got users.'
#    xhr.response