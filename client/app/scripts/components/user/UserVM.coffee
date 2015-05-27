m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require '../util/Validation'
require './user.es'


module.exports = class UserVM extends ViewModel

  constructor: () ->
    @modelName = 'User'
    @vm = UserVM
    @verb = 'user'
    @url = 'api/user'
    @homeRoute = '/users'
    # create clean hash map without object prototype - ECMAScript5
    # see: http://ryanmorr.com/true-hash-maps-in-javascript/
    @attributes = Object.create(null)
    @init()

  init: (meters) ->
    @attributes =
      id: m.prop ''
      email: m.prop '1@1.cc'
      nickname: m.prop ''
      firstname: m.prop ''
      lastname: m.prop ''
      password: m.prop ''

  @current: new UserVM
  createObj: -> new UserVM
  
  @validate: (obj) ->
    msgs = []
    test = (val) -> if val then msgs.push val
    test Validation.email obj.email(), {fieldName: 'Email'}
    test Validation.notNull obj.nickname(), {fieldName: 'Nickname'}
    test Validation.minChar obj.nickname(), {fieldName: 'Nickname', length: 3}
    msgs
    


