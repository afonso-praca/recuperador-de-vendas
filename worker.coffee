LIService = require './services/li'
liService = new LIService();
_ = require 'underscore'

ONE_MIN = 60 * 1000

queryAnalyzeAndAct = ->
  liService.getOrders().then (body) ->
    body = JSON.parse body
    console.log body
    _.each body.objects, (order) ->
      console.log order.resource_uri
      liService.getOrder(order.resource_uri)

try
  # Run every minute
  setInterval queryAnalyzeAndAct, ONE_MIN * 60
  # Run first time
  queryAnalyzeAndAct()


catch e
  console.error "Error!", e