express = require('express')
http = require('http')
http.globalAgent.maxSockets = 10
app = express()
cors = require('cors')
app.use(cors({credentials: true}))
bodyParser = require('body-parser')
app.use bodyParser.json()
app.use bodyParser.urlencoded { extended: true }
#cookieParser = require('cookie-parser')
#app.use cookieParser('este secreto no tiene pamfleto') # required before session.

expressJwt = require('express-jwt')
jwt = require('jsonwebtoken')
# We are going to protect /api routes with JWT
JWT_SECRET = 'SUPER SECRET STRING'
app.use '/api', expressJwt({secret: JWT_SECRET}).unless({path: ['/login']})
app.use (err, req, res, next) ->
  if err.name is 'UnauthorizedError' 
    console.log 401
    res.status(401).json {error: 'invalid token'}
#    res.status(401).send 'invalid token'
    

#session = require('express-session')
#app.use session({name: 'clasiserv.sid', secret: 'esta sessión no tiene calefacción'})
reload = require('reload')

#everyauth = require('everyauth')
#app.use everyauth.middleware(app)
#everyauth.password
#  .getLoginPath('/login') # Uri path to the login page
#  .postLoginPath('/login') # Uri path that your login form POSTs to
#  .loginView('a string of html; OR the name of the jade/etc-view-engine view')
  #.authenticate (login, password) ->



#app.use(less('./public'))
app.use(express.static('./public'))


#app.get '/favoritos', (req, res) ->
#  res.render('stdView', {view: 'favoritos'})
#favorites = require("./controller/favorites")
#app.use('/api/favoritos/', favorites.router)

app.post '/login', (req, res) ->
  console.log 'login'
#  if (!(req.body.username is 'john.doe' and req.body.password is 'foobar')) 
#    res.status(401).send {error: 'Wrong credentials'}
#    return

  el.getOne {typeName: 'user', q: "username:#{req.body.username} password:#{req.body.password}"}, (error, response) ->
    console.log 'el.error: ' + error
    console.log 'el.response: ' + JSON.stringify response
#    res.json response?._source
    
    profile = response._source
    delete profile.password
#    profile = 
#      firstname: 'John',
#      lastname: 'Doe',
#      email: 'john@doe.com',
#      _id: 123
    # We are sending the profile inside the token
    token = jwt.sign profile, JWT_SECRET, { expiresInMinutes: 60*5 }
    res.json { profile: profile, token: token }

    
app.get '/api/user', (req, res) ->
  el.getAll 'user', el.indexName, (error, response) ->
#    console.log JSON.stringify response
    res.json response

app.get '/api/user/:id', (req, res) ->
  el.getOne {typeName: 'user', q: "_id:#{req.params.id}"}, (error, response) ->
#    res.json response?._source
    res.json { id: response._id, obj: response?._source }

app.put '/api/user', (req, res) ->
#  console.log 'user: ' + JSON.stringify req.body
  el.index req.body.id, 'user', el.indexName, req.body, (error, response) ->
#    console.log "error: " + error
#    console.log "response: " + JSON.stringify response
#    res.json { _id: response._id }
    res.json { id: response._id, obj: req.body }


app.delete '/api/user', (req, res) ->
  console.log 'delete: ' + JSON.stringify req.body
  el.delete {type: 'user', index : el.indexName, id: req.body.id}, (error, response) ->
    console.log "error: " + error
    console.log "response: " + JSON.stringify response
    res.json { _id: response._id }


app.get '/api/right', (req, res) ->
  el.getAll 'right', el.indexName, (error, response) ->
    res.json response

app.get '/api/right/:id', (req, res) ->
  el.getOne {typeName: 'right', q: "_id:#{req.params.id}"}, (error, response) ->
#    res.json response?._source
    res.json { id: response._id, obj: response?._source }

app.put '/api/right', (req, res) ->
  el.index req.body.id, 'right', el.indexName, req.body, (error, response) ->
    console.log "req.body: " + JSON.stringify req.body
    console.log "response: " + JSON.stringify response
#    res.json { _id: response._id }
#    obj = req.body
#    obj._id = response._id
    res.json { id: response._id, obj: req.body }

app.delete '/api/right', (req, res) ->
  console.log 'right.delete: ' + JSON.stringify req.body
  el.delete {type: 'right', index : el.indexName, id: req.body.id}, (error, response) ->
    res.json { _id: response._id }


app.get '/api/role', (req, res) ->
  el.getAll 'role', el.indexName, (error, response) ->
    res.json response

app.get '/api/role/:id', (req, res) ->
  console.log "id: " + req.params.id
  el.getOne {typeName: 'role', q: "_id:#{req.params.id}"}, (error, response) ->
#    console.log "error: " + JSON.stringify error
#    console.log "response: " + JSON.stringify response
#    res.json response?._source
    res.json { id: response._id, obj: response?._source }

app.put '/api/role', (req, res) ->
  el.index req.body.id, 'role', el.indexName, req.body, (error, response) ->
#    res.json { _id: response._id }
    res.json { id: response._id, obj: req.body }

app.delete '/api/role', (req, res) ->
  el.delete {type: 'role', index : el.indexName, id: req.body.id}, (error, response) ->
    res.json { _id: response._id }
    

server = http.createServer(app)
reload(server, app, 1000)

server.listen 3017, () ->
  console.log('Listening on port %d', server.address().port)

el = require("./model/EL")


Array.prototype.remove = (args...) ->
  output = []
  for arg in args
    index = @indexOf arg
    output.push @splice(index, 1) if index isnt -1
  output = output[0] if args.length is 1
  output

            