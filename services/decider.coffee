mongoose = require 'mongoose'
orderSchema = require '../models/order'
Mailer = require '../libs/email'
Q = require 'q'
email = new Mailer()

class Decider

  ##################################
  # PRIVATE METHODS                #
  ##################################

  _CanceledOrders = mongoose.model('CanceledOrders', orderSchema)

  _sendEmailToClient = (order) ->
    email.sendEmail({
      name: order.cliente.nome
      orderId: order.numero
      createDate: new Date order.data_criacao
    })

  _analyseOrder = (orders) ->
    return false if orders.length is 0
    order = JSON.parse(orders[0])
    _CanceledOrders.find({ orderId: order.numero }, (error, recoveredOrders) ->
      return new Error(err) if error
      if recoveredOrders.length is 0
        orderToCancel = new _CanceledOrders
          orderId: order.numero
          clientName: order.cliente.nome
          clientId: order.cliente.id
          clientEmail: order.cliente.email
          createDate: new Date order.data_criacao

        orderToCancel.save((err, savedOrder) ->
          return new Error(err) if err
          console.log 'Order saved -> ' + savedOrder
          _sendEmailToClient(order)
          orders.shift()
          _analyseOrder(orders)
        )
      else
        orders.shift()
        _analyseOrder(orders)
    )

  ##################################
  # PUBLIC METHODS                 #
  ##################################

  constructor: () ->
    console.log 'Decider started'

  analyseCanceledOrders: (orders) ->
    console.log 'analyseCanceledOrders'
    _analyseOrder(orders)

module.exports = Decider