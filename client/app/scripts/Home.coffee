m = require 'mithril'
Module = require './components/abstract/Module'

module.exports = class Login extends Module

  onDeviceReady = () ->
    log('ready: ' + navigator?.camera)
    pictureSource = navigator.camera.PictureSourceType;
    log 'pictureSource: ' + pictureSource
    destinationType = navigator.camera.DestinationType
  #    log 'destinationType: ' + destinationType
  #    deviceId = device.uuid

  cameraSuccess = (imageData) ->
    log 'cameraSuccess'
    image = document.getElementById('myImage')
    image.src = "data:image/jpeg;base64," + imageData
    document.getElementById('here').innerHtml = image

  cameraError = (message) ->
    log('cameraError: ' + message)
  #    alert('Failed because: ' + message)    
  #    document.getElementById('here').innerText = message

  onSuccess = (contacts) ->
    alert('Found ' + contacts.length + ' contacts.', 'hfkjyg')

  onError = (contactError) ->
    alert('onError!')

  log = (txt) ->
    console.log txt
    node = document.getElementById('my-content')
    if node
      node.appendChild document.createTextNode txt
      node.appendChild document.createElement('br')
  
  @controller: () ->

    foto: () ->
      document.addEventListener("deviceready", onDeviceReady, false)
#      log('navigator: ' + JSON.stringify navigator)
#      console.log 'camera: ' + camera
#      log('camera: ' + navigator?.camera)
#      console.log 'camera: ' + window?.camera
#      console.log 'cameraSuccess: ' + cameraSuccess
      navigator?.camera?.getPicture(cameraSuccess, cameraError, {})
      false

    contacts: () ->
      if navigator.contacts
        options = new ContactFindOptions()
        #      options.filter   = "Bob"
        options.multiple = true
        options.desiredFields = [navigator.contacts.fieldType.id]
        fields = [navigator.contacts.fieldType.displayName, navigator.contacts.fieldType.name]
        navigator.contacts.find(fields, onSuccess, onError, options)
      else
        log 'no contact module'
      false      
      
  @view: (ctrl) ->
    [
      m('h2', 'Cordova Check')
      FORM {class: 'pure-form pure-form-stacked'}, [
        BUTTON {onclick: ctrl.foto, class: 'pure-button pure-button-primary'}, "Foto"
        SPAN ' '
        BUTTON {onclick: ctrl.contacts, class: 'pure-button pure-button-primary'}, "Contacts"
      ]
    ]

