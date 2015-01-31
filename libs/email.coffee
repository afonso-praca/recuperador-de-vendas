###
Module dependencies.
###

emailjs = require 'emailjs'
config = require '../config/email-config'

class Email

  constructor: ->
    @server = emailjs.server.connect config
    @emailOptions =
      from: "VTEX McFly <vtex.mcfly@gmail.com>"
      to: "Javascript <js@vtex.com.br>"
      subject: "McFly health alert"


  ##################################
  # PRIVATE METHODS                #
  ##################################

  _getDefaultEmailtext = (errorLog) ->
    throw new Error "errorLog.app property is required" if not errorLog.app?
    throw new Error "errorLog.version property is required" if not errorLog.version?
    throw new Error "errorLog.env property is required" if not errorLog.env?
    throw new Error "errorLog.message property is required" if not errorLog.message?

    return "app: #{errorLog.app} \n version: #{errorLog.version} \n env: #{errorLog.env} \n error log: #{errorLog.message} \n\n"

  ##################################
  # PUBLIC METHODS                 #
  ##################################

  sendErrorEmail: (callback) ->
    text = "Health is too low!"

    options = @emailOptions
    options.text = text

    @server.send options, callback

  sendManualRollbackEmail: (errorLog, callback) ->
    throw new Error '"errorLog" parameter is required' if not errorLog?
    
    text = _getDefaultEmailtext(errorLog)

    text += "Health is getting too low!"

    options = @emailOptions
    options.text = text

    @server.send options, callback

  sendAutomaticRollbackEmail: (errorLog, callback) ->
    throw new Error '"errorLog" parameter is required' if not errorLog?

    text = _getDefaultEmailtext(errorLog)
    text += "Health is critically low! \n I would automatically rollback now!"

    options = @emailOptions
    options.text = text

    @server.send options, callback

module.exports = Email
