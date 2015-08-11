Select2 = require 'select2'

module.exports = class Select2Helper

  #this view implements select2's `<select>` progressive enhancement mode
  @view: (ctrl, args, args2) ->
    args2.config = Select2.config args
    m "select", args2, [
      for id, obj of args.data
        selected = if obj.id in args.values then 'selected' else ''
        m "option", {value: obj.id, selected: selected}, obj.name
    ]
 
  Select2.config = (args) ->
    (element, isInitialized) ->
      if !isInitialized
        #set up select2 (only if not initialized already)
        el = $(element)
        el.select2().on "change", (e) ->
          m.startComputation()
          if (typeof args.onchange is "function")
            args.onchange(el.select2("val"))
          m.endComputation()
      