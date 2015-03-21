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
      cc: "Loja Pilates Lovers <loja@pilateslovers.com.br>"

  ##################################
  # PUBLIC METHODS                 #
  ##################################

  sendEmail: (data, callback) ->
    text = "Olá #{data.name.split(" ")[0]}, "
    text += "Seu pedido de número #{data.orderId}, criado em #{moment(data.createDate).format('DD/MM/YY')}, não foi concluído com sucesso. "
    text += "Gostaria de saber se você teve alguma dificuldade (as vezes o processo de pagamento é meio complicado) e se posso te ajudar de alguma maneira? "
    text += "Para realizar uma nova compra basta acessar http://www.pilateslovers.com.br/ "
    text += "Daniela Soria, Loja Pilates Lovers"

    htmlText = "<html>Olá <strong>#{data.name.split(" ")[0]}</strong>,<br/><br/>"
    htmlText +=  "Seu pedido de número #{data.orderId}, criado em #{moment(data.createDate).format('DD/MM/YY')}, não foi concluído com sucesso. "
    htmlText +=  "Gostaria de saber se você teve alguma dificuldade (as vezes o processo de pagamento é meio complicado) e se posso te ajudar de alguma maneira? "
    htmlText +=  "Para realizar uma nova compra basta acessar http://www.pilateslovers.com.br/ <br/>"
    htmlText +=  "Nos colocamos a disposição e agradecemos o interesse pela loja."
    htmlText +=  "<br/><br/><strong>Daniela Soria</strong>, <br/>Loja Pilates Lovers</html><br/>(21) 3593.4758<br/>http://www.pilateslovers.com.br"

    options = @emailOptions
    options.to = "#{data.name} <#{data.email}>"
    options.subject = "Pedido #{data.orderId} - Atendimento"
    options.text = text
    options.attachment =
      [
        data: htmlText
        alternative:true
      ]

    @server.send options, callback

module.exports = Email
