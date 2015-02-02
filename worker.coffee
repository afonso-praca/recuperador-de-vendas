LIService = require './services/li'
liService = new LIService();
_ = require 'underscore'
Mailer = require './libs/email'
email = new Mailer()

ONE_MIN = 60 * 1000

queryAnalyzeAndAct = ->
  liService.getOrders().then (body) ->
    body = JSON.parse body
    console.log body
    _.each body.objects, (order) ->
      console.log order.resource_uri
      liService.getOrder(order.resource_uri)

    email.sendEmail({
      name: "sunda"
      orderId: "123"
    })

try
  # Run every minute
  setInterval queryAnalyzeAndAct, ONE_MIN * 60
  # Run first time
  queryAnalyzeAndAct()


catch e
  console.error "Error!", e