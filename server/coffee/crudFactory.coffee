el = require("./model/EL")

exports.makeCrud = (app, verb, home='/api/') ->
  
  app.get "/api/#{verb}", (req, res) ->
    el.getAll verb, el.indexName, (error, response) ->
  #    console.log JSON.stringify response
      res.json response
  
  app.get "/api/#{verb}/:id", (req, res) ->
    el.getOne {typeName: verb, q: "_id:#{req.params.id}"}, (error, response) ->
      res.json { id: response._id, obj: response?._source }
  
  app.put "/api/#{verb}", (req, res) ->
  #  console.log 'user: ' + JSON.stringify req.body
    el.index req.body.id, verb, el.indexName, req.body, (error, response) ->
  #    console.log "error: " + error
  #    console.log "response: " + JSON.stringify response
  #    res.json { _id: response._id }
      res.json { id: response._id, obj: req.body }
  
  app.delete "/api/#{verb}", (req, res) ->
    console.log 'delete: ' + JSON.stringify req.body
    el.delete {type: verb, index : el.indexName, id: req.body.id}, (error, response) ->
      console.log "error: " + error
      console.log "response: " + JSON.stringify response
      res.json { _id: response._id }  