mongoose = require 'mongoose'
accountSchema = require '../models/account'
Q = require 'q'

class AccountService

  _Accounts = mongoose.model('Accounts', accountSchema)

  _getAccounts = () ->
    defer = Q.defer()
    _Accounts.find((error, accounts) ->
      return new Error(error) if error
      defer.resolve accounts
    )
    defer.promise

  constructor: () ->
    console.log 'AccountService'

  getAccounts: () ->
    _getAccounts()

module.exports = AccountService