m = require 'mithril'
T9n = require '../util/T9n'

module.exports = class Module

  @app: window.App
  @conf: @app.conf

  @msgSuccess: (msg) -> @app.message.success msg
  @msgError: (msg) -> @app.message.error msg
 
  xhrConfig: (xhr) =>
    xhr.setRequestHeader "Authorization", 'Bearer ' + window.sessionStorage.token


  @makeInput = (attr, field) ->
    [
      LABEL {}, T9n.get field
#      val = if attr[field] then attr[field] else ''
      INPUT {id: field, onchange: m.withAttr("value", attr[field]), value: attr[field]()}
#      INPUT {id: field, onchange: m.withAttr("value", attr[field]), value: val}
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
        if key isnt 'id'
#          console.log "value: " + value() + ' = ' + search + ': ' + value()?.indexOf(search)
          if value()?.indexOf(search) > -1
            found = false
      o.filter = found
      m.endComputation()
