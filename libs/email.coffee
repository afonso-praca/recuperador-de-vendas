###
Module dependencies.
###

emailjs = require 'emailjs'
config = require '../config/email'
moment = require 'moment'

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
    text = "Olá #{data.name.split(" ")[0]}, "
    text += "Seu pedido de número #{data.orderId}, criado em #{moment(data.createDate).format('DD/MM/YY')}, não foi concluído com sucesso. "
    text += "Gostaria de saber se você teve alguma dificuldade e se posso te ajudar de alguma maneira? Você é muito importante para nossa loja. "
    text += "Para realizar sua compra basta acessar http://www.pilateslovers.com.br/ "
    text += "Daniela Soria, Pilates Lovers"

    htmlText = "<html>Olá <strong>#{data.name.split(" ")[0]}</strong>,<br/>"
    htmlText +=  "Seu pedido de número #{data.orderId}, criado em #{moment(data.createDate).format('DD/MM/YY')}, não foi concluído com sucesso. "
    htmlText +=  "Gostaria de saber se você teve alguma dificuldade e se posso te ajudar de alguma maneira? Você é muito importante para nossa loja. "
    htmlText +=  "Para realizar sua compra basta acessar http://www.pilateslovers.com.br/ "
    htmlText +=  "<br/><strong>Daniela Soria</strong>, <br/>Pilates Lovers</html>"

    options = @emailOptions

    options.text = text
    options.attachment =
      [
        data: htmlText
        alternative:true
      ]

    @server.send options, callback

module.exports = Email
