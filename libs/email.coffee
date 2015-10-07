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

    @createCanceledOrderEmail = (data, emailOptions) =>
      text = "Olá #{data.name.split(" ")[0]}, "
      text += "Seu pedido de número #{data.orderId}, criado em #{moment(data.createDate).format('DD/MM/YYYY')}, não foi concluído com sucesso. "
      text += "Gostaria de saber se você teve alguma dificuldade (às vezes o processo de pagamento é meio complicado) "
      text += "e se posso te ajudar de alguma maneira. "
      text += "Para realizar uma nova compra basta acessar http://www.pilateslovers.com.br/ "
      text += "Nos colocamos à disposição e agradecemos o interesse pela loja. "
      text += "Daniela Soria, Loja Pilates Lovers"

      htmlText = "<html>Olá <strong>#{data.name.split(" ")[0]}</strong>,<br/><br/>"
      htmlText +=  "Seu pedido de número #{data.orderId}, criado em #{moment(data.createDate).format('DD/MM/YYYY')}, não foi concluído com sucesso. "
      htmlText +=  "Gostaria de saber se você teve alguma dificuldade (às vezes o processo de pagamento é meio complicado) "
      htmlText +=  "e se posso te ajudar de alguma maneira. "
      htmlText +=  "Para realizar uma nova compra basta acessar http://www.pilateslovers.com.br/ <br/>"
      htmlText +=  "Nos colocamos à disposição e agradecemos o interesse pela loja."
      htmlText +=  "<br/><br/><strong>Daniela Soria</strong>, <br/>Loja Pilates Lovers</html><br/>(21) 3593.4758<br/>http://www.pilateslovers.com.br"

      options = emailOptions
      options.to = "#{data.name} <#{data.email}>"
      options.subject = "Pedido #{data.orderId} - Atendimento"
      options.text = text
      options.attachment =
        [
          data: htmlText
          alternative:true
        ]

      return options;

    @createPaymentPendingOrderEmail = (data, emailOptions) =>
      text = "Olá #{data.name.split(" ")[0]}, "
      text += "Ainda não recebemos a confirmação do pagamento do boleto referente ao Pedido de venda de número #{data.orderId}, "
      text += "criado em #{moment(data.createDate).format('DD/MM/YYYY')}, "
      text += "no valor de R$ #{data.totalValue}. "
      text += "Seus produtos já estão separados. "
      text += "Aguardamos o pagamento do boleto para podermos lhe enviar. "
      text += "Caso o boleto já tenha sido pago, desconsidere esse email, pois em breve deve chegar a confirmação pra gente. "
      text += "Daniela Soria, Loja Pilates Lovers"

      htmlText = "<html>Olá <strong>#{data.name.split(" ")[0]}</strong>,<br/><br/>"
      htmlText +=  "Ainda não recebemos a confirmação do pagamento do boleto referente ao Pedido de venda de número #{data.orderId}, "
      htmlText +=  "criado em #{moment(data.createDate).format('DD/MM/YYYY')}, "
      htmlText +=  "no valor de <strong>R$ #{data.totalValue}</strong>. "
      htmlText +=  "Seus produtos já estão separados. Aguardamos o pagamento do boleto para podermos lhe enviar. <br/><br/>"
      htmlText +=  "Caso o boleto já tenha sido pago, desconsidere esse email, pois em breve deve chegar a confirmação pra gente."
      htmlText +=  "<br/><br/><strong>Daniela Soria</strong>, <br/>Loja Pilates Lovers</html><br/>(21) 3593.4758<br/>http://www.pilateslovers.com.br"

      options = emailOptions
      options.to = "#{data.name} <#{data.email}>"
      options.subject = "Pedido de Venda #{data.orderId} - Aguardando Pagamento"
      options.text = text
      options.attachment =
        [
          data: htmlText
          alternative:true
        ]

      return options;

    @createDeliveredOrderEmail = (data, emailOptions) =>
      text = "Olá #{data.name.split(" ")[0]}, "
      text += "Muito obrigado por ter comprado conosco. Agradecemos a confiança. Como foi essa experiência? "
      text += "Se tiver 3 minutos pra nos ajudar, pedimos a gentileza de responder essa pesquisa sobre sua compra. "
      text += "http://bit.ly/1NGIStO "
      text += "Daniela Soria, Loja Pilates Lovers"

      htmlText = "<html>Olá <strong>#{data.name.split(" ")[0]}</strong>,<br/><br/>"
      htmlText +=  "Muito obrigado por ter comprado conosco. Agradecemos a confiança. Como foi essa experiência? "
      htmlText +=  "Se tiver 3 minutos pra nos ajudar, pedimos a gentileza de responder essa pesquisa sobre sua compra.<br/><br/>"
      htmlText +=  "http://bit.ly/1NGIStO"
      htmlText +=  "<br/><br/><strong>Daniela Soria</strong>, <br/>Loja Pilates Lovers<br/>(21) 3593.4758<br/>http://www.pilateslovers.com.br</html>"

      options = emailOptions
      options.to = "#{data.name} <#{data.email}>"
      options.subject = "Como foi sua experiência de compra? Pedido #{data.orderId}"
      options.text = text
      options.attachment =
        [
          data: htmlText
          alternative:true
        ]

      return options;


  ##################################
  # PUBLIC METHODS                 #
  ##################################

  sendEmail: (data, type, callback) ->
    if (type isnt 'canceled' and type isnt 'paymentPending' and type isnt 'delivered')
      return false
    emailOptions = @emailOptions
    if (type is 'canceled')
      options = @createCanceledOrderEmail(data, emailOptions)
    if (type is 'paymentPending')
      options = @createPaymentPendingOrderEmail(data, emailOptions)
    if (type is 'delivered')
      options = @createDeliveredOrderEmail(data, emailOptions)

    @server.send options, callback

module.exports = Email
