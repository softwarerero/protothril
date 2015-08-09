el = require("./model/EL")

exports.makeCrud = (app, verb, home='/api/') ->
  
  app.get "/api/#{verb}", (req, res) ->
    console.log 'query: ' + JSON.stringify req.query
    params = {type: verb}
    if req.query.size
      params.size = req.query.size
    if req.query.from
      params.from = req.query.from
    el.getAll params, (error, response) ->
  #    console.log JSON.stringify response
      res.json response
  
  app.get "/api/#{verb}/:id", (req, res) ->
    el.getOne {typeName: verb, q: "_id:#{req.params.id}"}, (error, response) ->
      console.log "error: " + error
      console.log "response: " + JSON.stringify response
      res.json { id: response._id, obj: response?._source }
  
  app.put "/api/#{verb}", (req, res) ->
    updateFields = req.body
    el.getOne {typeName: verb, q: "_id:#{req.body.id}"}, (error, response) ->
      obj = response?._source || {}
      for k,v of updateFields
        obj[k] = v
#      obj.isActive = true
      params =
        type: verb
        id: req.body.id
        body: obj
      el.index params, (error, response) ->
#        console.log "error: " + error
#        console.log "response: " + JSON.stringify response
    #    res.json { _id: response._id }
        req.body.id = response._id
        res.json { id: response._id, obj: req.body }
  
  app.delete "/api/#{verb}", (req, res) ->
    console.log 'delete: ' + JSON.stringify req.body
    el.delete {type: verb, index : el.indexName, id: req.body.id}, (error, response) ->
      console.log "error: " + error
      console.log "response: " + JSON.stringify response
      res.json { id: response._id }  