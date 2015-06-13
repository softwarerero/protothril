Select2 = require 'select2'

module.exports = class Select2Helper

  #this view implements select2's `<select>` progressive enhancement mode
  @view: (ctrl, args, args2) ->
    args2.config = Select2.config args
    m "select", args2, [
#      if (typeof args.data?.map) is 'object'
      args.data.map (item) ->
        selected = if item.id() in args.values() then 'selected' else ''
        m "option", {value: item.id(), selected: selected}, item.name()
    ]
 
  Select2.config = (args) ->
#    console.log 'args: ' + JSON.stringify args
    (element, isInitialized) ->
      el = $(element)
      if !isInitialized 
        #set up select2 (only if not initialized already)
        el.select2().on "change", (e) ->
          m.startComputation()
          if (typeof args.onchange is "function")
            args.onchange(el.select2("val"))
          m.endComputation()
      