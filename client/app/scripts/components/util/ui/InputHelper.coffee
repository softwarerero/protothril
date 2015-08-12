module.exports = class InputHelper

  # use like: InputHelper.makeInput attr, 'lastname', {mask: '####-##-___-# $'}
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
      
  #use: InputHelper.makeRadioToggle attr, 'lastname', ['Hans', 'Franz']    
  @makeRadioToggle = (attr, label, values) ->

    field = attr[label]
    
    changed = () ->
      value = document.querySelector('input[name="mx"]:checked').id
#      console.log 'changed: ' + value
#      console.log label + ': ' + field()
      field(value)


    config = (element, isInitialized, context) ->
      if isInitialized then return
      element.addEventListener('click', changed)
    
    
    m "div", [
      m "label", t9n label
      for v in values
        options = {type: 'radio', id: v, name: 'mx', config: config}
        if (v is field())
          options.checked = 'checked'
        m "span", {class: "mx-button"}, [
          m "input", options
          m "label", {class: "", for: v}, t9n v
        ]
    ]
    