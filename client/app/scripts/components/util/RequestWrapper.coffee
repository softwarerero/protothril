m = require 'mithril'

module.exports = class RequestWrapper
  constructor: (@opts) ->
    me = this
    me.opts = @opts
    me.success = me.loading = me.failed = false
    me.errorStatus = me.errorBody = ''
    me.data = null
    me.opts.background = true

    me.opts.extract = (xhr) ->
      if(xhr.status >= 300) # error!
        me.failed = true	
        me.success = me.loading = false
        me.errorStatus = xhr.status
        me.errorBody = xhr.responseText
        m.redraw()
      return xhr.responseText

  go: () ->
    me = this
    me.loading = true 
    me.success = me.failed = false
    m.request(me.opts).then (mydata) -> # success!
      console.log 'success'
      me.success = true 
      me.failed = me.loading = false
      me.data = mydata
      m.redraw()
