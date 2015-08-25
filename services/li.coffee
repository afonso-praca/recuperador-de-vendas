Q = require 'q'
request = require 'request'
liConfig = require '../config/li.coffee'

class LIService
  constructor: () ->
    @baseUrl = "http://api.lojaintegrada.com.br"

  getOrders: () ->
    deferred = Q.defer()
    options =
      url: @baseUrl + "/api/v1/pedido/search/?since_numero=1957&situacao_id=8&limit=300&format=json&chave_api=#{liConfig.chave_api}&chave_aplicacao=#{liConfig.chave_aplicacao}"
    request options, (err, response, body) ->
      deferred.resolve body
    return deferred.promise

  getOrder: (orderUri) ->
    deferred = Q.defer()
    console.log orderUri
    options =
      url: @baseUrl + "#{orderUri}?format=json&chave_api=#{liConfig.chave_api}&chave_aplicacao=#{liConfig.chave_aplicacao}"
    request options, (err, response, body) ->
      return deferred.reject new Error(err) if err
      deferred.resolve body
    return deferred.promise

module.exports = LIService