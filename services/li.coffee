Q = require 'q'
request = require 'request'
liConfig = require '../config/li.coffee'

class LIService
  constructor: () ->
    @baseUrl = "http://api.lojaintegrada.com.br"

  getOrders: (sinceOrder, statusId, limit = 300) ->
    deferred = Q.defer()
    if (not sinceOrder or not statusId)
      throw new Error('invallid parameters');
    options =
      url: @baseUrl + "/api/v1/pedido/search/?since_numero=#{sinceOrder}&situacao_id=#{statusId}&limit=#{limit}&format=json&chave_api=#{liConfig.chave_api}&chave_aplicacao=#{liConfig.chave_aplicacao}"
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