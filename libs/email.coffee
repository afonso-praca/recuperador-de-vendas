###
Module dependencies.
###

emailjs = require 'emailjs'
config = require '../config/email-config'

class Email

  constructor: ->
    @server = emailjs.server.connect config
    @emailOptions =
      from: "Loja Pilates Lovers <loja@pilateslovers.com.br>"
      to: "Afonso Praça <afonsoinfo@gmail.com>"
      cc: "Afonso Praça <afonsoinfo@gmail.com>",
      subject: "Queremos saber mais de você"

  ##################################
  # PUBLIC METHODS                 #
  ##################################

  sendEmail: (data, callback) ->
    text = "Olá #{data.name}, aqui é Daniela Soria da Pilates Lovers. "
    text += "Percebemos que seu pedido de número #{data.orderId} não foi concluído com sucesso. "
    text += "Gostaria de saber se você teve alguma dificuldade e se posso te ajudar com isso? Você é muito importante para nossa loja. "
    text += "Para realizar sua compra basta acessar http://www.pilateslovers.com.br/"

    options = @emailOptions
    options.text = text

    @server.send options, callback

module.exports = Email
