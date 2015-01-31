###
Module dependencies.
###

request = require 'request'
Q = require 'q'
DeciderActions = require '../config/decider-actions'
Authenticator = require './authenticator'
Mailer = require '../libs/email'
Keen = require 'keen.io'

class Decider
  constructor: (@keen) ->
    throw new Error '"keen" parameter is required' if not @keen?

    @email = new Mailer()
    @auth = new Authenticator "lab@vtex.com.br", "2194031020"

  calculateActions: (health) =>
    throw new Error '"health" parameter is required' if not health?

    deferred = Q.defer()
    console.log 'Calculating necessary actions given current health'

    # TODO transform into semantic private functions that receive tresholds
    if health.ordersTrend.a > -0.8 and # Orders trend is positive or close to 0
        health.latencyTrend.a < 0.2 and # Latency trend is negative or close to 0
        health.errorsTrend.a < 0.2 # Errors trend is negative or close to 0
      console.log 'No action necessary'
      deferred.resolve(health)
      return deferred.promise

    # Some trends are negative, let's check for related publications in last 10 minutes
    extraction = new Keen.Query 'extraction', eventCollection: "publications", timeframe: "previous_10_minutes"

    console.log 'Fetching recent publications'
    @keen.run extraction, (err, response) ->
      throw err if err
      console.log 'Recent publications fetched'

      if not response.result? or response.result.length < 1
        console.log("No results found for publications in last 10 minutes")
        health.actions = [DeciderActions.MANUAL_ROLLBACK]
        deferred.resolve(health)
        return deferred.promise

      health.recentPublications or= []
      health.recentPublications.push publication for publication in response.result

      # If trends are only slightly bad, notification is enough
      if health.ordersTrend.a > -0.5 or
          health.latencyTrend.a < 0.5 or
          health.errorsTrend.a < 0.5
        health.actions = [DeciderActions.MANUAL_ROLLBACK]
        deferred.resolve(health)
        return deferred.promise

      # Else, signal we should attempt an automatic rollback
      health.actions = [DeciderActions.AUTOMATIC_ROLLBACK]
      deferred.resolve(health)
      return deferred.promise

  notify: (health) ->
    console.log 'TODO Sending notifications', health.actions
    return health

  rollback: (health) ->
    if health.actions and DeciderActions.AUTOMATIC_ROLLBACK in health.actions
      console.log 'TODO Request automatic rollback for publications', health.recentPublications
    return health

module.exports = Decider
