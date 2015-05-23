m = require 'mithril'

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
    