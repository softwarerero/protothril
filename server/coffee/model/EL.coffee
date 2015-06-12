elasticsearch = require('elasticsearch')
assert = require("yaba")
conf = require '../conf'

client = new elasticsearch.Client
#  host: 'localhost:9200',
  host: conf.elasticsearch.host || process.env.elasticsearch
  log: 'error'

exports.index_prefix = conf.appName + '.'  
exports.indexName = 'prototype00' # conf.elasticsearch.index
exports.typeName = null
#exports.hola = 'hola'

#exports.sayHola = ->
#  console.log 'hola2: ' + exports.hola

exports.ping = ->
  client.ping
    requestTimeout: 1000,
    # undocumented params are appended to the query string
    hello: "elasticsearch!"
  , (error) ->
    if (error)
      console.error('elasticsearch cluster is down!')
    else
      console.log('elasticsearch is well')

exports.count = (q='', callback=null, type=exports.typeName, index=exports.indexName) ->
  if ensureIndex(index)
    client.count {index: index, type: type, q: q}, (error, response, status) ->
      if callback
        callback(error, response.count)
  else
    if callback
      callback {error: 'no index'}

exports.index = (id, typeName=exports.typeName, indexName=exports.indexName, json, callback) ->
#  console.log "type " + type + ": " + JSON.stringify(json)
  client.index {index: indexName, type: typeName, id: id, body: json, refresh: true}, (error, response, status) ->
    if error
      console.log "error: " + error
      console.log "status: " + status
    if callback
      callback(error, response)
      
exports.getAll = (typeName=exports.typeName, indexName=exports.indexName, callback) ->
  client.search {size: 1000000, index: indexName, type: typeName, body: {query: {match_all: {}}}, filter: {'exists': 'fetchDate'}}, (error, response, status) ->
    if error
      console.log "error: " + error
      console.log "status: " + status
    else
      response = for hit in response.hits.hits
        obj = hit._source
        obj.id = hit._id
        obj     
    callback(error, response)

exports.getOne = (params={}, callback) ->
  params.size = params.size || 1
  params.index = params.index || exports.indexName
  console.log "params: " + JSON.stringify params
#  client.search {size: 1, index: index, type: type, q: q}, (error, response, status) ->
  client.search params, (error, response, status) ->
    if error
      console.log "error: " + error
      console.log "status: " + status
    if response
#      console.log "response: " + JSON.stringify response
      response = response.hits.hits[0]
    if callback
      callback(error, response)

#DEF_PAGE_SIZE = 20
#exports.get = (params={}, callback, type, index) ->
#  params.size = params.size || DEF_PAGE_SIZE
#  params.type = params.type || 'ad'
#  params.index = params.index || exports.indexName
#  params.defaultOperator = params.defaultOperator || 'AND'
#  params.allow_leading_wildcard = params.allow_leading_wildcard || false
#  params.q = params.q || ''
##  params.from = if params.from then params.from = params.from * DEF_PAGE_SIZE else 0
#  params.body =
#    aggregations:
#      price_stats:
#        stats:
#          field: 'precio'
#  if 'ad' is params.type
#    params.sort = "no:desc"
#  console.log "params: " + JSON.stringify params
#  client.search params, (error, response, status) ->
#    if error
#      console.log "error: " + error
#      console.log "status: " + status
#    callback(response)
#
#exports.mget = (params={}, callback, type, index) ->
#  params.type = params.type || 'ad'
#  params.index = params.index || exports.indexName
##  console.log "mget: " + JSON.stringify params
#  client.mget params, (error, response, status) ->
#    if error
#      console.log "error: " + error
#      console.log "status: " + status
#    callback(error, response)
#
#exports.getId = (params={}, callback) ->
#  params.index = params.index || exports.indexName
#  console.log "params: " + JSON.stringify params
#  client.get params, (error, response, status) ->
#    if error
#      console.log "error: " + error
#      console.log "status: " + status
##    if response
##      response = response.hits.hits[0]
#    if callback
#      callback(error, response)
#    
#    
#exports.countFetched = (callback) ->
#  client.count {index: exports.indexName, type: 'ad', filter: {'exists': 'fetchDate'}}, (error, response, status) ->
#    if error
#      console.log "error: " + error
#      console.log "status: " + status
#    console.log "count " + ": " + response.count
#    if callback
#      callback(response)
#
#exports.maxNo = (callback) ->
#  client.search
#    index: exports.indexName
#    type: 'ad'
#    fields: "no"
#    timeout: 20000
#    _source: false
#    stats: "no"
#    q: 'estado:leido estado:expirado'
#    body:
#      aggregations:
#        max_no:
#          max:
#            field: "no"
##            script: "doc['no'].value || 0"
#  , (error, response, status) ->
#    if error
#      console.log "error: " + error
#      console.log "status: " + status
#    callback(response.aggregations.max_no.value)
#    
#exports.facetCat1 = (callback) ->
#  client.search
#    index: exports.indexName
#    type: 'ad'
#    _source: false
#    q: 'estado:leido estado:expirado'
##    q: '_missing_:precio AND cat1:inmuebles_compra_venta fechaLeido:[2014-06-04 TO 2014-06-04]'
#    body:
#      aggregations:
#        cat1:
#          terms:
#            field: 'cat1'
#          aggregations:
#            cat2:
#              terms:
#                field: 'cat1'
#                field: 'cat2'
#  , (error, response, status) ->
#    if error
#      console.log "error: " + error
#      console.log "status: " + status
#    callback(response)
#
#
#exports.deleteAll = (type='', index=exports.indexName) ->
#  client.deleteByQuery {index: index, type: type, body: {query: {match_all: {}}}}, (error, response, status) ->
#    if error
#      console.log "deleteAll error: " + error
#      console.log "status: " + status
#    console.log "deleteByQuery " + type + ": " + JSON.stringify(response)

exports.delete = (params={}, callback=null) ->
  assert params.type
  assert params.index
#  params.type = params.type || 'ad'
#  params.index = params.index || exports.indexName
  client.delete params, (error, response, status) ->
    if error
      console.log "delete error: " + error
      console.log "status: " + status
    console.log "delete " + ": " + JSON.stringify(response)
    if callback
      callback(error, response)
      

ensureIndex = (index) ->
  if index
    exports.index_prefix + index
  else
    null
    