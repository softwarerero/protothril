m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
Validation = require '../util/Validation'
require './auth.es.coffee'
T9n = require '../util/T9n'


module.exports = class RightVM extends ViewModel

  constructor: () ->
    @modelName = 'Right'
    @vm = RightVM
    @verb = 'right'
    @url = 'api/right'
    @homeRoute = '/rights'
    @attributes = Object.create(null)
#    @filter = false
    @init()

  init: () ->
    @attributes =
      id: m.prop ''
      name: m.prop ''

  @current: new RightVM
  createObj: -> new RightVM

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
    for kev, values of @cache()
      if values.name is name
        return values
    return null
        