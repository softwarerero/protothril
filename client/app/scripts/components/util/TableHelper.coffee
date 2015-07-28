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
    console.log "cache: " + JSON.stringify @vm.cacheValues()
    @vm.cacheValues()?.map (o, index) ->
      found = true
      for key, value of o
        if key isnt 'id' and key isnt 'attrs' and key isnt 'filter'
          if value?.indexOf(search) > -1
            found = false
      o.filter = found
      m.endComputation()  