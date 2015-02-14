LIService = require './services/li'
DeciderService = require './services/decider'
_ = require 'underscore'
mongoose = require('mongoose')

liService = new LIService();
decider = new DeciderService();
ONE_MIN = 60 * 1000

queryAnalyzeAndAct = ->
  liService.getOrders().then (body) ->
    body = JSON.parse body
    _.each body.objects, (order) ->
      console.log order.resource_uri
      liService.getOrder(order.resource_uri)
    decider.analyseCanceledOrders()

mongoose.connect(process.env.MONGOLAB_URI)
onDbConnected = ->
  console.log 'connected to mongo db'
  try
    # RUN EVERY HOUR
    setInterval queryAnalyzeAndAct, ONE_MIN * 60
    # RUN FIRST TIME
    queryAnalyzeAndAct()
  catch e
  console.error "Error!", e

# ALL CODE MUST RUN AFTER PERSISTENT DATA CONNECTION HAS BEEN ESTABLISHED
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  onDbConnected()