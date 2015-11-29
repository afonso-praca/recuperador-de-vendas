Q = require 'q'
request = require 'request'

class LIService
  constructor: () ->
    @baseUrl = "http://api.lojaintegrada.com.br"

  getOrders: (account, statusId, config = {}) ->
    deferred = Q.defer()
    if (not statusId)
      throw new Error('invallid parameters');
    options =
      url: @baseUrl + "/api/v1/pedido/search/?situacao_id=#{statusId}&format=json&chave_api=#{account.apiKey}&chave_aplicacao=#{account.appKey}"

    if (config.sinceOrder)
      options.url+="&since_numero=#{config.sinceOrder}"
    if (config.lastUpdate)
      options.url+="&since_atualizado=#{config.lastUpdate}"
    if (config.limit)
      options.url+="&limit=#{config.limit}"
    else
      options.url+="&limit=300"

    request options, (err, response, body) ->
      deferred.resolve body
    return deferred.promise

  getOrder: (account, orderUri) ->
    deferred = Q.defer()
    options =
      url: @baseUrl + "#{orderUri}?format=json&chave_api=#{account.apiKey}&chave_aplicacao=#{account.appKey}"
    request options, (err, response, body) ->
      return deferred.reject new Error(err) if err
      deferred.resolve body
    return deferred.promise

module.exports = LIService