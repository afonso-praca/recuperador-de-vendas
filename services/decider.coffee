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

  analyseCanceledOrders: (retrivedOrders) ->
    console.log 'analyseCanceledOrders'

    for order in retrivedOrders
      order = JSON.parse(order)

      orderToCancel = new @CanceledOrders
        orderId: order.numero
        clientName: order.cliente.nome
        clientId: order.cliente.id
        clientEmail: order.cliente.email
        createDate: new Date order.data_criacao

      @CanceledOrders.find({ orderId: order.numero }, (error, recoveredOrders) ->
        if error
          return new Error(err)
        if recoveredOrders.length is 0
          sendEmailToClient(order)
          orderToCancel.save((err, savedOrder) ->
            if err
              return new Error(err)
            console.log 'Order saved -> ' + savedOrder
          )
      )

module.exports = Decider