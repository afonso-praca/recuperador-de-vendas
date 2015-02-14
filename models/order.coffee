mongoose = require('mongoose')

orderSchema = mongoose.Schema
  orderId: Number
  clientId: Number
  clientName: String
  clientEmail: String
  createDate: Date

module.exports = orderSchema