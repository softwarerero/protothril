m = require 'mithril'
ViewModel = require '../abstract/ViewModel'


module.exports = class UserVM extends ViewModel

  constructor: () ->
    super()
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
    @pageSize = 3
    

  init: () ->
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
    validation = new Validation()
    validation.test 'email', Validation.notNull obj.email(), {fieldName: T9n.get('email')}
    validation.test 'email', Validation.email obj.email(), {fieldName: T9n.get('email')}
#    validation.test 'nickname', Validation.notNull obj.nickname(), {fieldName: T9n.get('nickname')}
#    validation.test 'nickname', Validation.minLength obj.nickname(), {fieldName: T9n.get('nickname'), length: 3}
    validation.test 'password', Validation.notNull obj.password(), {fieldName: T9n.get('password')}
    validation.test 'password', Validation.minLength obj.password(), {fieldName: T9n.get('password'), length: 5}
    validation
    
  filters:
    field: 'email'

