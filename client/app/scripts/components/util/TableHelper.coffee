module.exports = class TableHelper

  constructor: (@vm) ->
    
  sorts: (e) =>
    prop = e.target.getAttribute("data-sort-by")
    list = @vm.cache()

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

 
  filter: (e) =>
    search = document.getElementsByClassName('search')[0].value
    m.startComputation()
    @vm.cache()?.map (o, index) ->
      found = true
      for key, value of o.attributes
        if key isnt 'id'
#          console.log "value: " + value() + ' = ' + search + ': ' + value()?.indexOf(search)
          if value()?.indexOf(search) > -1
            found = false
      o.filter = found
      m.endComputation()  