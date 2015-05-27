m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require '../util/Validation'
require './user.es'


#module.exports = class UserVM extends ViewModel
#  constructor: () ->
#    @move()
#
#  move: (meters) ->
#    console.log " moved #{meters}m."

module.exports = class UserVM extends ViewModel

#  @users: m.prop([])
  
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
  
  cache: () ->
    window.caches[@verb]?()
#    console.log 'ViewModel.caches[@verb]: ' + !!ViewModel.caches[@verb]
#    if not ViewModel.caches[@verb]
#      console.log 2
##      ViewModel.caches[@verb] = m.prop []
#      console.log 3
#      @all (x) ->
#        console.log 'fill cache'
#        ViewModel.caches[@verb] = m.prop x
#        callback x
  setCache: (x) ->
#    if not ViewModel.caches[@verb].length
#    cache = ViewModel.caches[@verb]
#    if not cache
#      cache = m.prop []
#    cache(x)
    window.caches[@verb] = m.prop x
  
  @validate: (obj) ->
    msgs = []
    test = (val) -> if val then msgs.push val
    test Validation.email obj.email(), {fieldName: 'Email'}
    test Validation.notNull obj.nickname(), {fieldName: 'Nickname'}
    test Validation.minChar obj.nickname(), {fieldName: 'Nickname', length: 3}
    msgs
    

  createObj: -> new UserVM

