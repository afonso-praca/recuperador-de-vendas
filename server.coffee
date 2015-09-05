LIService = require './services/li'
DeciderService = require './services/decider'
_ = require 'underscore'
mongoose = require('mongoose')
Q = require 'q'

liService = new LIService();
decider = new DeciderService();
ONE_MIN = 60 * 1000

queryAnalyzeAndAct = ->
  # CANCELED ORDERS
  liService.getOrders(1957, 8).then (body) ->
    body = JSON.parse body
    ordersRequests = []
    _.each body.objects, (order) ->
      ordersRequests.push liService.getOrder(order.resource_uri)
    Q.all(ordersRequests).then (orders) ->
      decider.analyseCanceledOrders orders

  # PAYMENT PENDING ORDERS
  liService.getOrders(1, 2).then (body) ->
    body = JSON.parse body
    paymentPendidgOrdersRequests = []
    _.each body.objects, (order) ->
      paymentPendidgOrdersRequests.push liService.getOrder(order.resource_uri)
    Q.all(paymentPendidgOrdersRequests).then (orders) ->
      decider.analysePaymentPendingOrders orders

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