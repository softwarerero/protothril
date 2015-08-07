m = require 'mithril'
T9n = require 'T9n'
Login = require './auth/Login'

module.exports = class Menu

  @controller = () ->

  @view = () ->
  
    return m "div", {class: 'pure-menu pure-menu-horizontal'},
#      m('p', Login.loggedIn())
#      m('p', Login.username()) 
      m 'ul', {class: 'pure-menu-list'}, [ 
        m 'li', {class: 'pure-menu-item pure-menu-has-children pure-menu-allow-hover'}, [
          m 'a', {class: 'pure-menu-link', href: '#'}, T9n.get 'Admin'
          m 'ul', {class: 'pure-menu-children'}, [
            mlink '/users', T9n.get 'Users'
            mlink '/roles', T9n.get 'Roles' 
            mlink '/rights', T9n.get 'Rights'
          ]
        ]
        if Login.loggedIn()
          mlink '/logout', (T9n.get 'Logout') + ' (' + Login.username() + ')'
        else
          mlink '/login', T9n.get 'Login'
      ]
 

  mlink = (href, txt) -> 
    [m 'li', {class: 'pure-menu-item'}, m 'a[href="' + href + '"]', {config: m.route, class: 'pure-menu-link'}, txt]

#  mlinkSep = (href, txt) ->
#    [m 'li', {class: 'pure-menu-item'}, ' | ' , m 'a[href="' + href + '"]', {config: m.route, class: 'pure-menu-link'}, txt]    