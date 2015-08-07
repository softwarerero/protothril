m = require 'mithril'
T9n = require 'T9n'

module.exports = class Module

  @app: window.App
  @conf: @app.conf

  @msgSuccess: (msg) -> @app.message.success msg
  @msgError: (msg) -> @app.message.error msg
 
  xhrConfig: (xhr) =>
    xhr.setRequestHeader "Authorization", 'Bearer ' + window.sessionStorage.token


  @makeInput = (attr, field) ->
    [
#      console.log '@makeInput.attr: ' + JSON.stringify attr
#      attr = attr.attributes
#      console.log '@makeInput.attr: ' + typeof attr
#      console.log 'field: ' + field
#      val = attr[field]?()
#      console.log 'val: ' + val
      LABEL {for: field}, T9n.get field
#      val = if attr[field] then attr[field] else ''
      INPUT {id: field, onchange: m.withAttr("value", attr[field]), value: attr[field]?()}
#      INPUT {id: field, onchange: m.withAttr("value", @setAttribute[field]), value: attr[field]?()}
    ]

    
  @setAttribute = (name) ->
    console.log '@setAttribute: ' + name