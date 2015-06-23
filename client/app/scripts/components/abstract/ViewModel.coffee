m = require 'mithril'
T9n = require '../util/T9n'

module.exports = class ViewModel

  @app: window.App
  @conf: @app.conf
  window.caches = {} # if caches are stored at window level different windows can edit different objects


  cloneAttributes: (obj, vm) ->
    obj.init()
    for key, value of vm
      if value
        obj.attributes[key]?(value)
    obj
    
  xhrConfig: (xhr) =>
    xhr.setRequestHeader "Authorization", 'Bearer ' + window.sessionStorage.token

  goHome: ->
    console.log '@homeRoute: ' + @homeRoute
    m.route @homeRoute
    
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
  
#  allRequest: -> {method: "GET", url: ViewModel.conf.url + "#{@url}", config: @xhrConfig}    
     
  all: (callback) ->
    if not window.caches[@verb] 
#      console.log 'url: ' + ViewModel.conf.url + "#{@url}"
#      request = {method: "GET", url: ViewModel.conf.url + "#{@verb}", config: @xhrConfig, extract: @extract}
#      request = {method: "GET", url: ViewModel.conf.url + "#{@url}", config: @xhrConfig}
      request = @stdRequest()
      @loadingRequest(request).then (xhr, xhrOptions) =>
#        console.log 'all.xhr: ' + xhr
        objs = [] 
        for o in xhr
          obj = @createObj()
          @cloneAttributes obj, o
          objs.push obj
        @vm.current.setCache objs
        @msgSuccess 'Got data.' 
        if callback
          callback(objs)  
          

  save: () ->
    request = {method: "PUT", url: ViewModel.conf.url + "#{@url}", config: @xhrConfig, data: @getAttributes()}
    @loadingRequest(request).then (xhr, xhrOptions) =>
      if @attributes.id()
        objs = @cache().filter (o) ->
          o.attributes.id() isnt xhr._id
        objs.push @vm.current
        @vm.current.setCache objs
      else
        @vm.current.attributes.id xhr._id
        @cache().push @vm.current
      @msgSuccess T9n.get 'crud.saved', {modelName: @modelName}
      m.redraw()
    false

  delete: (id) =>
    data = {id: id}
    request = {method: "DELETE", url: ViewModel.conf.url + "#{@url}", config: @xhrConfig, data: data}
    @loadingRequest(request).then (xhr, xhrOptions) =>
      objs = @cache().filter (o) ->
        o.attributes.id() isnt xhr._id
      @vm.current.setCache objs
      @msgSuccess T9n.get 'crud.deleted', {modelName: @modelName}
    false    
    
  
  getForId: (id) =>
    if not id then return
    objs = @cache()
    if objs?.length
      objs = objs.filter (o) ->
        o.attributes.id() is id
      @vm.current = objs[0]
    else
      console.log 'GET: ' + ViewModel.conf.url + "#{@url}/#{id}"
      request = {method: "GET", url: ViewModel.conf.url + "#{@url}/#{id}", config: @xhrConfig}
      @loadingRequest(request).then (xhr, xhrOptions) =>
        if not xhr
          @msgError T9n.get 'no data'
          @goHome()
        @cloneAttributes @vm.current, xhr
  
          
  cache: () ->
    if not window.caches[@verb]
      @all (objs) ->
        objs
    else
      window.caches[@verb]?()

  setCache: (x) ->
    window.caches[@verb] = m.prop x


  getAttributes: () ->
    obj = {}
    for k, v of @attributes
      if !!v()
        obj[k] = v() 
    obj
 
  extract: (xhr, xhrOptions) ->
#    console.log 'extract.xhr: ' + xhr
#    console.log 'xhrOptions: ' + JSON.stringify xhrOptions
    if xhr.status is 401  
#      @msgError xhr.response.error
      response = JSON.parse xhr.response
#      console.log 'response: ' + JSON.stringify response.error
      ViewModel.app.message.error T9n.get response.error  
      loading.style.display = "none"
      m.route '/login'
      xhr
    xhr.response

  deserialize:  (xhr, xhrOptions) ->
#    console.log 'deserialize.xhr: ' + xhr
#    console.log 'deserialize.xhrOptions: ' + xhrOptions
#    console.log 'response: ' + JSON.stringify xhr.response
#    console.log 'error: ' + JSON.stringify xhr.error
#    console.log 'error: ' + JSON.stringify xhr.response.error
#    if xhr.status is 401
#      @msgError xhr.response.error
#      response = JSON.parse xhr.response
#      response = xhr.response
#      console.log 'response: ' + response
#      console.log 'response: ' + response.error
#      ViewModel.app.message.error T9n.get response.error
#      loading.style.display = "none"
#      m.route("/login")
#    response = JSON.parse xhr.response
#    if response?.error then response.error else response
#    JSON.parse xhr.response
#    response?.error
    JSON.parse xhr
    
    
    