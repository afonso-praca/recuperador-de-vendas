LIService = require './services/li'
DeciderService = require './services/decider'
AccountService = require './services/account'
_ = require 'underscore'
mongoose = require('mongoose')
Q = require 'q'

liService = new LIService();
decider = new DeciderService();
accountService = new AccountService();

ONE_MIN = 60 * 1000
ONE_HOUR = ONE_MIN * 60
ONE_DAY = ONE_HOUR * 24

makeOrdersRequests = (account, orders, callback) ->
  ordersRequests = []
  _.each orders, (order) ->
    ordersRequests.push liService.getOrder(account, order.resource_uri)
  Q.all(ordersRequests).then (ordersResult) ->
    callback(account, ordersResult)

queryOrders = (account, statusId, params, callback) ->
  liService.getOrders(account, statusId, params).then (body) ->
    body = JSON.parse body
    makeOrdersRequests(account, body.objects, (account, orders) ->
      callback(account,orders)
    )

# CANCELED ORDERS
queryCanceledOrders = (account) ->
  queryOrders(account, 8, { sinceOrder: 1957 }, decider.analyseCanceledOrders)

# PAYMENT PENDING ORDERS
queryPaymentPendingOrders = (account) ->
  queryOrders(account, 2, { sinceOrder: 1 }, decider.analysePaymentPendingOrders)

# DELIVERED ORDERS
queryDeliveredOrders = (account) ->
  compareDate = new Date()
  compareDate.setTime(compareDate.getTime() - (15 * ONE_DAY))
  lastUpdateDate = [compareDate.getFullYear(), compareDate.getMonth()+1, compareDate.getDate()].join("-")
  queryOrders(account, 14, { lastUpdate: lastUpdateDate }, decider.analyseDeliveredOrders)

mongoose.connect(process.env.MONGOLAB_URI)
onDbConnected = ->
  console.log 'connected to mongo db'
  accountService.getAccounts().then((accounts) ->
    for account in accounts
      try
        # RUN ON INTERVAL
        setInterval queryCanceledOrders, ONE_MIN * 15, account
        setInterval queryPaymentPendingOrders, ONE_HOUR * 3, account
        setInterval queryDeliveredOrders, ONE_HOUR * 6, account
        # RUN FIRST TIME
        queryCanceledOrders(account)
        queryPaymentPendingOrders(account)
        queryDeliveredOrders(account)
      catch e
        console.error "Error!", e
  )

# ALL CODE MUST RUN AFTER PERSISTENT DATA CONNECTION HAS BEEN ESTABLISHED
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  onDbConnected()