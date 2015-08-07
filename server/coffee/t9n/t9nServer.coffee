T9n = require '../../../shared/util/T9n'

if not T9n.isDefined 'appName'
  T9n.map "es", require './es'
  T9n.map "en", require './en'
  T9n.map "de", require './de'
  T9n.setLanguage 'es'

module.exports = (x, params) -> T9n.get(x, params)  