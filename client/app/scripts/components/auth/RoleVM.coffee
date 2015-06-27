m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require '../util/Validation'
require './auth.es.coffee'
T9n = require '../util/T9n'


module.exports = class RoleVM extends ViewModel

  constructor: () ->
    @modelName = 'Role'
    @vm = RoleVM
    @verb = 'role'
    @url = 'api/role'
    @homeRoute = '/roles'
    @attributes = Object.create(null)
    #    @filter = false
    @init()

  init: () ->
    @attributes =
      id: m.prop ''
      name: m.prop ''
      rights: m.prop []

  @current: new RoleVM
  createObj: -> new RoleVM

  @validate: (obj) ->
    msgs = []
    test = (field, val) ->
      if val
        obj =
          name: field
          msg: val
        msgs.push obj
    test 'name', Validation.notNull obj.name(), {fieldName: T9n.get('name')}
    msgs

  forName: (name) ->
#    console.log 'cache: ' + JSON.stringify @cache()
    for kev, values of @cache()
#      console.log 'attributes: ' + JSON.stringify values
#      console.log 'name: ' + JSON.stringify values.name
#      console.log 'is: ' + (values.name is name)
      if values.name is name
        idForName = values.id
        return values
    return null
    