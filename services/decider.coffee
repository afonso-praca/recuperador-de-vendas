mongoose = require 'mongoose'
orderSchema = require '../models/order'
Mailer = require '../libs/email'
Q = require 'q'
email = new Mailer()

sendEmailToClient = (order) ->
  email.sendEmail({
    name: order.cliente.nome
    orderId: order.numero
  })

class Decider
  constructor: () ->
    @CanceledOrders = mongoose.model('CanceledOrders', orderSchema)

  analyseCanceledOrders: (orders) ->
    console.log 'analyseCanceledOrders'

    for order in orders
      order = JSON.parse(order)
      sendEmailToClient(order)

      orderToCancel = new @CanceledOrders
        orderId: order.numero
        clientName: order.cliente.nome

      orderToCancel.save((err, order) ->
        if (err)
          console.error err
        console.log order
      )

      @CanceledOrders.find({ oderId: order.numero }, (err, order) ->
        if !err
          console.log order
      )

module.exports = Decider