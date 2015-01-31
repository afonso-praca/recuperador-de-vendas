###
Mofule dependencies.
###

request = require 'request'
Q = require 'q'


urls =
  vtexIdEndpoints:
    start: "https://vtexid.vtex.com.br/api/vtexid/pub/authentication/start"
    validate: "https://vtexid.vtex.com.br/api/vtexid/pub/authentication/classic/validate"

class Authenticator

  constructor: (login, password) ->
    throw new Error '"login" parameter is required' if not login?
    throw new Error '"login" parameter should be a String' if typeof login isnt "string"
    throw new Error '"password" parameter is required' if not password?
    throw new Error '"password" parameter should be a String' if typeof password isnt "string"

    @fluxCredentials =
      login: login
      password: password

  ##################################
  # PRIVATE METHODS                #
  ##################################

  _request_get = (url) ->
    deferred = Q.defer()
    request.get url, (err, res, body) ->
      if err
        console.log err
        deferred.reject err
      else
        deferred.resolve body

    return deferred.promise

  ##################################
  # PUBLIC METHODS                 #
  ##################################

  getVtexIdAuthCookie: ->
    _request_get(urls.vtexIdEndpoints.start)
      .then (body) ->
        authObj = JSON.parse body
        token = authObj.authenticationToken

        return token

      .then (token) =>
        params =
          authToken: "authenticationToken=#{token}"
          login: "login=#{@fluxCredentials.login}"
          pass: "password=#{@fluxCredentials.password}"

        validateParams = "#{params.authToken}&#{params.login}&#{params.pass}"
        validateUrl =  "#{urls.vtexIdEndpoints.validate}?#{validateParams}"

        return validateUrl

      .then _request_get

      .then (body) ->
        authObj = JSON.parse body
        cookieObj = authObj.authCookie

        cookie = "#{cookieObj.Name}=#{cookieObj.Value}"
        
        return cookie


module.exports = Authenticator