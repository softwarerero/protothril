m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require '../util/Validation'
require './user.es'

module.exports = class UserVM extends ViewModel

  @current: new UserVM
  @users: m.prop([])

  constructor: ->
    @modelName = 'User'
    @vm = UserVM
    @verb = 'api/user'
    @homeRoute = '/users'
    @attributes = 
      id: m.prop ''
      email: m.prop '1@1.cc'
      nickname: m.prop ''
      firstname: m.prop ''
      lastname: m.prop ''
      password: m.prop ''

  cache: () -> @vm.users()
  setCache: (x) -> @vm.users(x)
  
#  all: ->
#    console.log 'hi: ' + not @cache().length
#    if not @cache().length
#      console.log 'userlist url: ' + Model.conf.url + 'api/user'
#      request = {method: "GET", url: Model.conf.url + 'api/user', config: @xhrConfig, extract: @extract}
#      m.request(request).then (xhr, xhrOptions) =>
#        @cache([])
#        for u in xhr
#          user = new UserVM()
#          for k, v of u
#            user.attributes[k](v)
#          @cache().push user
#        @cache().map (u, index) ->
#          attr = u.attributes
#    @cache()

  @validate: (obj) ->
    msgs = []
    test = (val) -> if val then msgs.push val
    test Validation.email obj.email(), {fieldName: 'Email'}
    test Validation.notNull obj.nickname(), {fieldName: 'Nickname'}
    test Validation.minChar obj.nickname(), {fieldName: 'Nickname', length: 3}
    msgs
    

  createObj: -> new UserVM

