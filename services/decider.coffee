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
  _PaymentPendingOrders = mongoose.model('PaymentPendingOrders', orderSchema)

  _sendEmailToClient = (order, type) ->
    email.sendEmail({
      name: order.cliente.nome
      orderId: order.numero
      createDate: new Date order.data_criacao
      email: order.cliente.email,
      totalValue: String(order.valor_total).replace('.', ',')
    }, type)

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
          totalValue: order.valor_total

        orderToCancel.save((err, savedOrder) ->
          return new Error(err) if err
          console.log 'Order saved -> ' + savedOrder
          _sendEmailToClient(order, 'canceled')
          orders.shift()
          _analyseOrder(orders)
        )
      else
        orders.shift()
        _analyseOrder(orders)
    )

  _analysePaymentPendingOrders = (orders) ->
    return false if orders.length is 0
    order = JSON.parse(orders[0])
    _PaymentPendingOrders.find({ orderId: order.numero }, (error, recoveredOrders) ->
      return new Error(err) if error
      if recoveredOrders.length is 0
        orderToSendPaymentEmail = new _PaymentPendingOrders
          orderId: order.numero
          clientName: order.cliente.nome
          clientId: order.cliente.id
          clientEmail: order.cliente.email
          createDate: new Date order.data_criacao
          totalValue: order.valor_total

        orderToSendPaymentEmail.save((err, savedOrder) ->
          return new Error(err) if err
          console.log 'Order saved -> ' + savedOrder
          _sendEmailToClient(order, 'paymentPending')
          orders.shift()
          _analysePaymentPendingOrders(orders)
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

  analysePaymentPendingOrders: (orders) ->
    console.log 'analysePaymentPendingOrders'
    _analysePaymentPendingOrders orders

module.exports = Decider