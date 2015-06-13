m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require '../util/Validation'
T9n = require '../util/T9n'


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
    @filter = false
    @init()

  init: (meters) ->
    @attributes =
      id: m.prop ''
      email: m.prop '1@1.cc'
      nickname: m.prop ''
      firstname: m.prop ''
      lastname: m.prop ''
      password: m.prop ''
      birthday: m.prop ''
      rols: m.prop []

  @current: new UserVM
  createObj: -> new UserVM
   
  @validate: (obj) ->
    msgs = []
    test = (field, val) -> 
      if val
        obj = 
          name: field
          msg: val
        msgs.push obj
    test 'email', Validation.email obj.email(), {fieldName: T9n.get('email')}
    test 'nickname', Validation.notNull obj.nickname(), {fieldName: T9n.get('nickname')}
    test 'nickname', Validation.minLength obj.nickname(), {fieldName: T9n.get('nickname'), length: 3}
    msgs
    
  filters:
    field: 'email'

