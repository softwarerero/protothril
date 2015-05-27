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
#app.use '/api', expressJwt({secret: JWT_SECRET}).unless({path: ['/login']})
#app.use (err, req, res, next) ->
#  if err.name is 'UnauthorizedError' 
#    console.log 401
#    res.status(401).send('invalid token...')

#session = require('express-session')
#app.use session({name: 'clasiserv.sid', secret: 'esta sessión no tiene calefacción'})
reload = require('reload')
#less = require('less-middleware')
#app.use(require("connect-assets")({paths: ["./client/coffee"]}))

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
#  console.log req.body
#  res.send('ok')
#  res
#    .cookie('username', req.params.user)
#  .res.clearCookie('username') # clearing a cookie
# Cookie: user=tobi.CP7AWaXDfAKIRfH49dQzKJx7sKzzSoPq7/AcBBRVwlI3
#req.signedCookies.user
#    .cookie('username', 'whoever', {expires: new Date() + 99999, maxAge: 99999, httpOnly: true, signed: true})
#    .cookie('username', 'whoever', {expires: new Date() + 99999, maxAge: 99999, httpOnly: false, signed: true})
#    .send({msg: 'This is CORS-enabled for all origins!'})
  if (!(req.body.username is 'john.doe' and req.body.password is 'foobar')) 
    res.send(401, 'Wrong user or password')
    return
  
  profile = 
    firstname: 'John',
    lastname: 'Doe',
    email: 'john@doe.com',
    _id: 123
  # We are sending the profile inside the token
  token = jwt.sign profile, JWT_SECRET, { expiresInMinutes: 60*5 }
  res.json { token: token }

#users = [
#  {email: 'john@prototype.org.py', nickname: 'John'}
#  {nickname: 'Hans'}
#  {nickname: 'Mike'}
#]
    
app.get '/api/user', (req, res) ->
  Users.all (result) ->
#    res.json { users: result }
    res.json result

app.get '/api/user/:id', (req, res) ->
#  console.log 'id1: ' + JSON.stringify JSON.stringify req.params.id
  Users.getOne req.params.id, (result) ->
#    res.json { users: result }
    res.json result

app.put '/api/user', (req, res) ->
  console.log 'user: ' + JSON.stringify req.body
#  attr = req.body
#  attr._id = attr.id
#  delete attr.id
#  console.log 'user: ' + JSON.stringify req.body
  el.index req.body.id, 'user', el.indexName, req.body, (error, response) ->
    console.log "error: " + error
    console.log "response: " + JSON.stringify response
    res.json { _id: response._id }
#    Users.all (result) ->
#      res.json { users: result }
  #  users.push req.body
#  res.json { users: users }


app.delete '/api/user', (req, res) ->
  console.log 'delete: ' + JSON.stringify req.body
#  users.remove req.body
#  res.json { users: users }
  el.delete {type: 'user', index : el.indexName, id: req.body.id}, (error, response) ->
    console.log "error: " + error
    console.log "response: " + JSON.stringify response
    res.json { _id: response._id }
#    Users.all (result) ->
#      res.json { users: result }

server = http.createServer(app)
reload(server, app, 1000)

server.listen 3017, () ->
  console.log('Listening on port %d', server.address().port)

el = require("./model/EL")
#console.log 'hola: ' + el.hola
#el.sayHola()
#el.hola = 'hi'
#el.sayHola()
##console.log 'hola: ' + el.hola
#el.ping()
#el.count '', (err, data) ->
#  console.log err
#  console.log data
#  el.sayHola()


Array.prototype.remove = (args...) ->
  output = []
  for arg in args
    index = @indexOf arg
    output.push @splice(index, 1) if index isnt -1
  output = output[0] if args.length is 1
  output

class Users

  @all: (callback) ->
#    console.log 'getAll'
    el.getAll 'user', el.indexName, (error, response) ->
#      console.log "error: " + JSON.stringify error
#      console.log "response: " + JSON.stringify response.hits.hits
      attrs = ['nickname', 'email', 'firstname', 'lastname']
      result = for hit in response.hits.hits
#        console.log "i: " +  JSON.stringify hit._source
        obj = { id: hit._id }
        for attr in attrs
          obj = Users.appendHit hit._source, obj, attr
        obj
#      console.log "result: " + JSON.stringify result
      callback result

    @appendHit = (hit, obj, field) ->
      if hit[field]
        obj[field] = hit[field]
      obj

  @getOne: (id, callback) ->
    console.log "id: " + JSON.stringify id
    el.getOne {q: "id:#{id}"}, (error, response) ->
      console.log "error: " + JSON.stringify error
      console.log "response: " + JSON.stringify response
      callback response?._source
      