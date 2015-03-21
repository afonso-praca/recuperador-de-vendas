LIService = require './services/li'
DeciderService = require './services/decider'
_ = require 'underscore'
mongoose = require('mongoose')
Q = require 'q'

liService = new LIService();
decider = new DeciderService();
ONE_MIN = 60 * 1000

queryAnalyzeAndAct = ->
  liService.getOrders().then (body) ->
    body = JSON.parse body
    ordersRequests = []
    _.each body.objects, (order) ->
      ordersRequests.push liService.getOrder(order.resource_uri)
    Q.all(ordersRequests).then (orders) ->
      decider.analyseCanceledOrders(orders)

mongoose.connect(process.env.MONGOLAB_URI)
onDbConnected = ->
  console.log 'connected to mongo db'
  try
    # RUN EVERY HOUR
    setInterval queryAnalyzeAndAct, ONE_MIN * 15
    # RUN FIRST TIME
    queryAnalyzeAndAct()
  catch e
    console.error "Error!", e

# ALL CODE MUST RUN AFTER PERSISTENT DATA CONNECTION HAS BEEN ESTABLISHED
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  onDbConnected()