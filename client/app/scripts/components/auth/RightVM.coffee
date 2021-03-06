m = require 'mithril'
ViewModel = require '../abstract/ViewModel'
require './auth.es.coffee'


module.exports = class RightVM extends ViewModel

  constructor: () ->
    super()
    @modelName = 'Right'
    @vm = RightVM
    @verb = 'right'
    @url = 'api/right'
    @homeRoute = '/rights'
    @attributes = Object.create(null)
    @init()

  init: () ->
    @attributes =
      id: m.prop ''
      name: m.prop ''

  @current: new RightVM
  createObj: -> new RightVM

  @validate: (obj) ->
    validation = new Validation()
    validation.test 'name', Validation.notNull obj.name(), {fieldName: T9n.get('name')}
    validation

  forName: (name) ->
    for kev, values of @cache()
      if values.name is name
        return values
    return null
        