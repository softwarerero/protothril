m = require 'mithril'
T9n = require '../util/T9n'

module.exports = class ViewModel

  @app: window.App
  @conf: @app.conf
  window.caches = {} # if caches are stored at window level different windows can edit different objects


  xhrConfig: (xhr) =>
    xhr.setRequestHeader "Authorization", 'Bearer ' + window.sessionStorage.token

  goHome: -> m.route @homeRoute
    
  msgSuccess: (msg) -> ViewModel.app.message.success msg
  msgError: (msg) -> ViewModel.app.message.error msg
  msgWarn: (msg) -> ViewModel.app.message.warn msg
    
     
  loadingRequest: (args) ->
    loading = document.getElementById("loading")
    loading.style.display = "block"
    m.request(args).then (value, err) ->
      loading.style.display = "none"
      value
      
  stdRequest: =>
    method: 'GET'
    url: ViewModel.conf.url + "#{@url}"
    config: @xhrConfig
    extract: @extract
    deserialize: @deserialize 
     
  all: (callback) ->
    if not window.caches[@verb] 
      @loadingRequest(@stdRequest()).then (xhr, xhrOptions) =>
        if xhr
          console.log 'xhr: ' + JSON.stringify xhr
          objs = Object.create(null)
          for obj in xhr
            objs[obj.id] = obj
          @vm.current.setCache objs
          if callback
            callback(objs)
           

  save: () ->
    console.log 'save'
    request = {method: "PUT", url: ViewModel.conf.url + "#{@url}", config: @xhrConfig, data: @getAttributes()}
    @loadingRequest(request).then (xhr, xhrOptions) =>
#      console.log 'save.xhr: ' + JSON.stringify xhr
      @cache()[xhr.id] = xhr.obj
#      console.log 'save.@cache(): ' + JSON.stringify @cache()
      @msgSuccess T9n.get 'crud.saved', {modelName: @modelName}
    false
 
    
  delete: (id) =>
    data = {id: id}
    request = {method: "DELETE", url: ViewModel.conf.url + "#{@url}", config: @xhrConfig, data: data}
    @loadingRequest(request).then (xhr, xhrOptions) =>
      delete @cache()[xhr.id]
      @msgSuccess T9n.get 'crud.deleted', {modelName: @modelName}
    false    
    
  
  getForId: (id) =>
    if not id then return
    objs = @cache()
    if objs[id]
      @cloneAttributes @vm.current, objs[id]
    else
      console.log 'GET: ' + ViewModel.conf.url + "#{@url}/#{id}"
      request = {method: "GET", url: ViewModel.conf.url + "#{@url}/#{id}", config: @xhrConfig}
      @loadingRequest(request).then (xhr, xhrOptions) =>
        if not xhr
          @msgError T9n.get 'no data'
          @goHome()
        else
          @cloneAttributes @vm.current, xhr.obj
          @vm.current.attributes.id xhr.id
          objs[xhr.id] = xhr.obj 
  
          
  cache: () ->
    if not window.caches[@verb]
      @all (objs) ->
        objs
    else
      window.caches[@verb]?()

  setCache: (x) ->
    window.caches[@verb] = m.prop x

  # get array of object from cache
  cacheValues: -> value for own prop, value of @cache()

  getAttributes: () ->
    obj = {}
    for k, v of @attributes
      if 'function' is typeof v and v()
#      if !!v
        obj[k] = v()
    obj

  cloneAttributes: (obj, vm) ->
    obj.init()
    for key, value of vm
      if value
        obj.attributes[key]?(value)
    obj

  
  extract: (xhr, xhrOptions) ->
#    console.log 'xhr.status: ' + xhr.status
    if xhr.status is 401  
      response = JSON.parse xhr.response
      ViewModel.app.message.error T9n.get response.error  
      loading.style.display = "none"
      m.route '/login'
      xhr
    xhr.response

  deserialize: (xhr, xhrOptions) ->
    JSON.parse xhr
    
    
    