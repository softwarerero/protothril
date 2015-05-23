m = require 'mithril'

module.exports = class Message

  message = m.prop('')
  clazz = m.prop('')
  TIMEOUT = 3000

  # the controller defines what part of the model is relevant for the current page
  # in our case, there's only one view-model that handles everything
  @controller = () ->

  # here's the view
  @view = (ctrl) ->
    m('div', {class: clazz()}, message())

  @error = (msg) ->
    clazz 'error'
    @setMsg msg
    
  @success = (msg) ->
    clazz 'success'
    @setMsg msg
    
  @warn = (msg) ->
    clazz 'warn'
    @setMsg msg

  @setMsg = (msg) ->
    message msg
    setTimeout @clear, TIMEOUT
    m.redraw()
    
    
  @clear = () ->
    console.log 'clear'
    message ''
    clazz 'none'
    m.redraw true

  @loading = ->
    message m("img.loader[src=loading.gif]", {style: {display: "none"}})
