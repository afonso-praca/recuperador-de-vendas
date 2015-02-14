mongoose = require('mongoose')
orderSchema = require('../models/order')
Mailer = require '../libs/email'

class Decider
  constructor: () ->
    @CanceledOrders = mongoose.model('CanceledOrders', orderSchema)
    @email = new Mailer()

  analyseCanceledOrders: () ->
    email.sendEmail({
      name: "Elias Maluco"
      orderId: "1552"
    })

    orderToCancel = new CanceledOrders({ orderId: 1552, clientName: "Elias Maluco" })
    orderToCancel.save((err, order) ->
      if (err)
        console.error err
      console.log order
    )

    CanceledOrders.find
      id: 1552
    , (err, order) ->
      if err
        return
      console.log order

module.exports = Decider