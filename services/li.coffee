Q = require 'q'
request = require 'request'
liConfig = require '../config/li-config.coffee'

class LIService
	constructor: () ->
    @baseUrl = "http://api.lojaintegrada.com.br";

  getOrders: () ->
    deferred = Q.defer()
    options =
      url: @baseUrl + "/api/v1/pedido/search/?since_numero=1540&situacao_id=8&limit=10&format=json&chave_api=#{liConfig.chave_api}&chave_aplicacao=#{liConfig.chave_aplicacao}"
    console.log "Fetching orders = #{options.url}"
    request options, (err, response, body) ->
      deferred.resolve body
    return deferred.promise

  getOrder: (orderUri) ->
    options =
      url: @baseUrl + "#{orderUri}?format=json&chave_api=#{liConfig.chave_api}&chave_aplicacao=#{liConfig.chave_aplicacao}"

    console.log "Fetching order"
    request options, (err, response, body) ->
      console.log body


module.exports = LIService