# use like: InputHelper.makeInput attr, 'lastname', {mask: '####-##-___-# $'}
module.exports = class InputHelper
  
  @makeInput = (attr, field, params) ->
    changeHandler = if params.mask
      setMaskValue(attr[field])
    else
      m.withAttr("value", attr[field])
    [
      LABEL {for: field}, t9n field
      input = INPUT {config: applyDataMask, id: field, onchange: changeHandler, value: attr[field]?(), 'data-mask': params.mask}
    ]

  applyDataMask = (element, isInitialized, context) ->
    if isInitialized then return
    mask = element.dataset.mask
    if not mask then return
  
    # Replace `#` characters with characters from `data`
    applyMask = (data) ->
      newMask = for char in mask
        if char isnt '#'
          char
        else if data.length is 0
          char
        else 
          data.shift()
      newMask.join('')
    
    reapplyMask = (data) ->
      applyMask(stripMask(data))
  
    changed = () ->
      oldStart = element.selectionStart
      oldEnd = element.selectionEnd
      element.value = reapplyMask(element.value)
      element.selectionStart = oldStart
      element.selectionEnd = oldEnd
  
    element.addEventListener('click', changed)
    element.addEventListener('keyup', changed)

  # For now, this just strips everything that's not a number
  stripMask = (maskedData) ->
    isDigit = (char) -> /\d/.test(char)
    maskedData.split('').filter(isDigit)

  setMaskValue = (field) ->
    (e) -> 
      value = e.currentTarget.value
      value = stripMask value
      value = value.join ''
      field value