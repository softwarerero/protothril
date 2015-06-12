m = require 'mithril'
T9n = require './util/T9n'

module.exports = class Menu

  # the controller defines what part of the model is relevant for the current page
  # in our case, there's only one view-model that handles everything
  @controller = () ->

  # here's the view
  @view = () ->
    return m "div", {class: 'pure-menu pure-menu-horizontal'}, 
#      m('span', ' | ')
      m 'div', {class: 'pure-menu-list'}, [
        mlink '/users', T9n.get 'Users'
        mlink '/rights', T9n.get 'Rights'
        mlink '/roles', T9n.get 'Roles'
        mlink '/login', T9n.get 'Login' 
#        mlinkSep '/rights', T9n.get 'Rights' 
#        mlinkSep '/roles', T9n.get 'Roles' 
#        mlinkSep '/login', T9n.get 'Login'
      ]
 

  mlink = (href, txt) ->
    [m 'li', {class: 'pure-menu-item'}, m 'a[href="' + href + '"]', {config: m.route, class: 'pure-menu-link'}, txt]

  mlinkSep = (href, txt) ->
    [m 'li', {class: 'pure-menu-item'}, ' | ' , m 'a[href="' + href + '"]', {config: m.route, class: 'pure-menu-link'}, txt]    