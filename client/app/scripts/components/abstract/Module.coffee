m = require 'mithril'
T9n = require '../util/T9n'

module.exports = class Module

  constructor: () ->

#  controller: () ->
#    console.log 'controller: ' + @app


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
    