module.exports = class TableHelper

  constructor: (@vm) ->
    
  sorts: (e) =>
    prop = e.target.getAttribute("data-sort-by")
    list = @vm.cache()
    if prop
      first = list[0]
      list.sort (a, b) ->
        return a[prop] > b[prop] ? 1 : a[prop] < b[prop] ? -1 : 0
      for n in e.target.parentNode.childNodes
        n.className = ''
      if (first is list[0])
        e.target.className = 'desc'
        list.reverse()
      else
        e.target.className = 'asc'

 
  filter: (e) =>
    search = document.getElementsByClassName('search')[0].value
    m.startComputation()
#    console.log "cache: " + JSON.stringify @vm.cacheValues()
    @vm.cacheValues()?.map (o, index) ->
      found = true
      for key, value of o
        if key isnt 'id' and key isnt 'activationId' and key isnt 'password' and typeof value is 'string'
          if value?.indexOf(search) > -1
            found = false
      o.filter = found
      m.endComputation()

  
  makeTable: (ctrl, objs, theads, tdata) ->
#    console.log 'vm: ' + JSON.stringify @vm
    FORM {class: 'pure-form'}, [
      INPUT {class: 'search', placeholder: 'Search', oninput: ctrl.tableHelper.filter}
    ],
    TABLE {class: 'pure-table pure-table-striped', style: 'width: auto'}, [
      THEAD [
        TR [
          theads()
          TH( I {class: 'fa fa-plus action th-action', onclick: m.withAttr('dataid', ctrl.add)} )
        ]
      ]
      TBODY {class: 'list'}, [
        for id, obj of objs
          if not obj.filter
            TR {class: 'tableRow'}, [
              tdata(obj)
              TD {style: ''}, [
                I {class: 'fa fa-pencil-square-o action', onclick: m.withAttr('dataid', ctrl.edit), dataid: obj.id}
                SPAN ' '
                I {class: 'fa fa-trash action', onclick: m.withAttr('dataid', ctrl.delete), dataid: obj.id}
              ]
            ]
      ]
      if @vm.pageSize < @vm.total
        TFOOT [
          TR {class: 'tableFooter'}, [
            TD t9n 'crud.showFromTo', {from: @vm.from, to: Math.min(@vm.from+@vm.pageSize,@vm.total), total: @vm.total}
            TD {colspan: tdata(obj).length}, [
              I {class: 'fa fa-fast-backward action', onclick: m.withAttr('dataid', ctrl.first)}
              I {class: 'fa fa-step-backward action', onclick: m.withAttr('dataid', ctrl.previous)}
              I {class: 'fa fa-step-forward action', onclick: m.withAttr('dataid', ctrl.next)}
              I {class: 'fa fa-fast-forward action', onclick: m.withAttr('dataid', ctrl.last)}
            ]
          ]
        ]
    ]
          