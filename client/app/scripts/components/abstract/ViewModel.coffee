m = require 'mithril'
T9n = require '../util/T9n'

module.exports = class ViewModel

  @app: window.App
  @conf: @app.conf


  cloneAttributes: (vm) ->
    obj = @createObj()
    console.log 'cloneAttributes: ' + JSON.stringify vm.attributes
    for key, value of vm.attributes
      console.log 'cloneAttributes: ' + value()
      if value()
        obj.attributes[key](value())
    console.log 'obj: ' + JSON.stringify obj
    obj
    
  xhrConfig: (xhr) =>
    xhr.setRequestHeader "Authorization", 'Bearer ' + window.sessionStorage.token

  goHome: ->
    console.log '@homeRoute: ' + @homeRoute
    m.route @homeRoute
    
  msgSuccess: (msg) -> ViewModel.app.message.success msg
    
  loadingRequest: (args) ->
    loading = document.getElementById("loading")
    loading.style.display = "block"
    m.request(args).then (value) ->
      loading.style.display = "none"
      value

  all: () ->
    if not @cache().length
      console.log 'url: ' + ViewModel.conf.url + "#{@verb}"
      request = {method: "GET", url: ViewModel.conf.url + "#{@verb}", config: @xhrConfig, extract: @extract}
      @loadingRequest(request).then (xhr, xhrOptions) =>
        @cache([])
        for u in xhr
          obj = @createObj()
          for k, v of u
            obj.attributes[k](v)
          @cache().push obj
        @cache().map (u, index) ->
          attr = u.attributes
        m.redraw()
    @cache


  save: () =>
    request = {method: "PUT", url: ViewModel.conf.url + "#{@verb}", config: @xhrConfig, data: @attributes}
    @loadingRequest(request).then (xhr, xhrOptions) =>
      if not @attributes.id()
        obj = @cloneAttributes @vm.current
        obj.attributes.id(xhr._id)
        @cache().push obj
      @msgSuccess T9n.get 'crud.saved', {modelName: @modelName}
      @goHome()
    false

  delete: (id) =>
    data = {id: id}
    request = {method: "DELETE", url: ViewModel.conf.url + "#{@verb}", config: @xhrConfig, data: data}
    @loadingRequest(request).then (xhr, xhrOptions) =>
      console.log "xhr: " + JSON.stringify xhr
      users = @cache().filter (u) ->
        u.attributes.id() isnt xhr._id
      @vm.current.setCache users
      @msgSuccess T9n.get 'crud.deleted', {modelName: @modelName}
    false    