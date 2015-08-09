module.exports = class Validation

  @notNull: (x, params) -> if !!x then null else @makeMsg 'validation.notNull', params
  @minLength: (x, params) -> if x?.length >= params.length then null else @makeMsg 'validation.minLength', params
  @maxLength: (x, params) -> if x?.length < params.length then null else @makeMsg 'validation.minLength', params
  @min: (x, params) -> if x >= params.min then null else @makeMsg 'validation.min', params
  @max: (x, params) -> if x >= params.max then null else @makeMsg 'validation.max', params

  # http://code.tutsplus.com/tutorials/8-regular-expressions-you-should-know--net-6149
  @regEx: (x, regex, msg, params) -> if x.match regex then null else @makeMsg msg, params
  @username: (x, params) -> @regex x, /^[a-z0-9_-]{3,16}$/, params
  @slug: (x, params) -> @regex x, /^[a-z0-9-]+$/, params
  @url: (x, params) -> @regex x, /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, params
  @ipaddress: (x, params) -> @regex x, /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/, params
  @htmlTag: (x, params) -> @regex x, /^<([a-z]+)([^<]+)*(?:>(.*)<\/\1>|\s+\/>)$/, params
  @email: (x, params) ->
    @regEx x, /// ^ #begin of line
      ([\w.-]+)         #one or more letters, numbers, _ . or -
      @                 #followed by an @ sign
      ([\w.-]+)         #then one or more letters, numbers, _ . or -
      \.                #followed by a period
      ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
      $ ///i, 'validation.email', params
    
  @makeMsg: (error, params) -> {msg: error, params: params}

  constructor: () ->
    @msgs = []

  test: (name, val) ->
    if val
      val.params = val.params || {}
      val.params.fieldName = name
      @msgs.push 
        name: name
        error: val.msg
        params: val.params
    
  isValid: -> !@msgs.length
  isInvalid: -> !!@msgs.length

window?.Validation = @Validation = Validation
