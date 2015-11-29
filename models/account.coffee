mongoose = require('mongoose')

accountSchema = mongoose.Schema
  name: String
  apiKey: String
  appKey: String
  emailAddress: String
  emailPassword: String
  emailHost: String
  emailUseSSL: Boolean
  signature: String
  storeUrl: String
  surveyUrl: String

module.exports = accountSchema