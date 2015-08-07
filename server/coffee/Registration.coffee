conf = require './conf'
Validation = require '../../client/app/scripts/components/util/Validation'
t9n = require('./t9n/t9nServer')
uuid = require('node-uuid')
el = require("./model/EL")

module.exports = class Registration

  nodemailer = require('nodemailer')
  transporter = nodemailer.createTransport(conf.smtp)

  @register: (req, res) ->
    console.log 'ip: ' + req.ip
    console.log 'protocol: ' + req.protocol
    console.log 'hostname: ' + req.hostname
    console.log 'subdomains: ' + req.subdomains
    console.log 'host: ' + req.get('host')
    console.log 'originalUrl: ' + req.originalUrl
    console.log 'register: ' + JSON.stringify req.body
    validation = new Validation()
    validation.test 'email', Validation.notNull req.body.email
    validation.test 'email', Validation.email req.body.email
    validation.test 'password', Validation.notNull req.body.password
    validation.test 'password', Validation.minLength(req.body.password, {length: 5})
    console.log 'msgs: ' + JSON.stringify validation.msgs
    console.log 'validation.isValid(): ' + validation.isValid()
    if validation.isInvalid()
      res.status(400).json validation.msgs[0]
    else
      el.getOne {type: 'user', q: "email:#{req.body.email}"}, (error, response) =>
        console.log 'error: ' + JSON.stringify error
        console.log 'response: ' + JSON.stringify response
        if response
          res.status(400).json {error: 'registration.duplicate_user'}
        else
          body = req.body
          body.apps = [conf.appName] # check in the future if user is auhorized fo appName
          body.isActive = false
          body.activationId = uuid.v4()
          console.log 'body: ' + JSON.stringify body
          @sendConfirmationMail req, body
          el.index {type: 'user', body: req.body}, (error, response) ->
            console.log 'el.error: ' + error
            console.log 'el.response: ' + JSON.stringify response
            res.status(200).json {msg: 'registration.success', id: response._id, obj: req.body }
  
  @sendConfirmationMail = (req, body) ->
    console.log '@sendConfirmationMail'
    mailOptions =
      from: conf.appEmail
      to: body.email
      subject: t9n 'registration.email.confirmation.title', {appName: t9n 'appName'}
      html: t9n 'registration.email.confirmation.html', {host: conf.frontend, email: body.email, token: body.activationId, appName: t9n 'appName'}

    console.log JSON.stringify mailOptions
    transporter.sendMail mailOptions, (error, info) ->
      if error
        console.log(error)
      else
        console.log('Message sent: ' + info.response)

  @confirmRegistration: (req, res) ->
    email = req.body.email
    token = req.body.token
#    console.log 'params: ' + JSON.stringify req.params
    el.getOne {type: 'user', q: "+email:#{email} +activationId:#{token}"}, (error, response) ->
      console.log 'error: ' + JSON.stringify error
      console.log 'response: ' + JSON.stringify response
      if response
        body = response._source
        body.isActive = true
        params =
          type: 'user'
          id: response._id
          body: body
        console.log "params: " + JSON.stringify params
  #     el.index req.body.id, verb, el.indexName, req.body, (error, response) ->
        el.index params, (error, response) ->
          console.log 'error: ' + JSON.stringify error
          console.log 'response: ' + JSON.stringify response
          res.status(200).json {msg: 'registration.complete'}
      else
        res.status(400).json {error: 'registration.notfound'}
        