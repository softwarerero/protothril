express = require('express')
http = require('http')
http.globalAgent.maxSockets = 10
app = express()
cors = require('cors')
uuid = require('node-uuid')
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
JWT_SECRET = secretKey = uuid.v4()
app.use '/api', expressJwt({secret: JWT_SECRET}).unless({path: ['/login', '/register', '/confirmRegistration']})
app.use (err, req, res, next) ->
  if err.name is 'UnauthorizedError' 
    console.log 401
    res.status(401).json {error: 'invalid token'}
#    res.status(401).send 'invalid token'
    

#session = require('express-session')
#app.use session({name: 'clasiserv.sid', secret: 'esta sessión no tiene calefacción'})
reload = require('reload')

#app.use(less('./public'))
app.use(express.static('./public'))

el = require("./model/EL")
#el.createMapping()

app.post '/login', (req, res) ->
  console.log 'login'
  el.getOne {type: 'user', q: "+email:#{req.body.email} +password:#{req.body.password}"}, (error, response) ->
    if response
      profile = response._source
      if profile.isActive
        delete profile.password
        # We are sending the profile inside the token
        token = jwt.sign profile, JWT_SECRET, { expiresInMinutes: 60*5 }
        res.json { profile: profile, token: token }
      else
        res.status(400).json {error: 'registration.notconfirmed'}        
    else
      res.status(400).json {error: 'registration.notfound'}

Registration = require("./Registration")    
app.post '/register', (req, res) ->
  Registration.register req, res
#http://127.0.0.1:9000/confirmRegistration/test@sun.com.py/ca5b0402-2574-4a14-b4a6-0a7198fb91a0  
app.post '/confirmRegistration', (req, res) -> Registration.confirmRegistration req, res
  


crudFactory = require("./crudFactory")
crudFactory.makeCrud app, 'user'
crudFactory.makeCrud app, 'right'
crudFactory.makeCrud app, 'role'

server = http.createServer(app)
reload(server, app, 1000)

server.listen 3017, () ->
  console.log('Listening on port %d', server.address().port)



#Array.prototype.remove = (args...) ->
#  output = []
#  for arg in args
#    index = @indexOf arg
#    output.push @splice(index, 1) if index isnt -1
#  output = output[0] if args.length is 1
#  output

            