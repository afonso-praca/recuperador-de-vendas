LIService = require './services/li'
DeciderService = require './services/decider'
_ = require 'underscore'
mongoose = require('mongoose')
Q = require 'q'

liService = new LIService();
decider = new DeciderService();

ONE_MIN = 60 * 1000
ONE_HOUR = ONE_MIN * 60
ONE_DAY = ONE_HOUR * 24

makeOrdersRequests = (orders, callback) ->
  ordersRequests = []
  _.each orders, (order) ->
    ordersRequests.push liService.getOrder(order.resource_uri)
  Q.all(ordersRequests).then (ordersResult) ->
    callback ordersResult

queryOrders = (statusId, params, callback) ->
  liService.getOrders(statusId, params).then (body) ->
    body = JSON.parse body
    makeOrdersRequests(body.objects, (orders) ->
      callback orders
    )

# CANCELED ORDERS
queryCanceledOrders = ->
  queryOrders(8, { sinceOrder: 1957 }, decider.analyseCanceledOrders)

# PAYMENT PENDING ORDERS
queryPaymentPendingOrders = ->
  queryOrders(2, { sinceOrder: 1 }, decider.analysePaymentPendingOrders)

# DELIVERED ORDERS
queryDeliveredOrders = ->
  compareDate = new Date()
  compareDate.setTime(compareDate.getTime() - (15 * ONE_DAY))
  lastUpdateDate = [compareDate.getFullYear(), compareDate.getMonth()+1, compareDate.getDate()].join("-")
  queryOrders(14, { lastUpdate: lastUpdateDate }, decider.analyseDeliveredOrders)

mongoose.connect(process.env.MONGOLAB_URI)
onDbConnected = ->
  console.log 'connected to mongo db'
  try
    # RUN ON INTERVAL
    setInterval queryCanceledOrders, ONE_MIN * 15
    setInterval queryPaymentPendingOrders, ONE_HOUR * 3
    setInterval queryDeliveredOrders, ONE_HOUR * 6
    # RUN FIRST TIME
    queryCanceledOrders()
    queryPaymentPendingOrders()
    queryDeliveredOrders()
  catch e
    console.error "Error!", e

# ALL CODE MUST RUN AFTER PERSISTENT DATA CONNECTION HAS BEEN ESTABLISHED
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  onDbConnected()