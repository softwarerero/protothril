m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require 'Validation'
require './auth.es.coffee'
T9n = require 'T9n'

# For a shared user between multiple applications roles like 'appname.rolename' can be used.
module.exports = class RoleVM extends ViewModel

  constructor: () ->
    @modelName = 'Role'
    @vm = RoleVM
    @verb = 'role'
    @url = 'api/role'
    @homeRoute = '/roles'
    @attributes = Object.create(null)
    @init()

  init: () ->
    @attributes =
      id: m.prop ''
      name: m.prop ''
      rights: m.prop []

  @current: new RoleVM
  createObj: -> new RoleVM

  @validate: (obj) ->
    validation = new Validation()
    validation.test 'name', Validation.notNull obj.name(), {fieldName: T9n.get('name')}
    validation

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
    