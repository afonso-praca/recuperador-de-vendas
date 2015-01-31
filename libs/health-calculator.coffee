###
Module dependencies.
###

_ = require 'underscore'

class HealthCalculator

  constructor: ->

  ##################################
  # PRIVATE METHODS                #
  ##################################

  _weightedAverage = (valuesArray) ->
    # Clones array
    values = valuesArray.slice(0)
    values.reverse()

    totalWeight = 0

    weightedSum = _.reduce values, (memo, value, index) ->
      weight = index + 1
      totalWeight += weight
      sum = value * weight
      return memo + sum
    , 0

    return weightedSum / totalWeight

  _calculatePercentage = (n1, n2) ->
    return 0 if n1 is 0 or n2 is 0

    part = n1 / n2
    percentage = part * 100
    formatedPercentage = parseFloat percentage.toFixed(2)

    return formatedPercentage

  _calculateVariation = (variations) ->

    variationsPartialSum = _.reduce variations, (memo, value, index) ->
      return memo + 0 if value is 0

      partCalc = 1 - (value/100)
      return memo + partCalc
    , 0

    sumPercentage = -(1 * variationsPartialSum) * 100

    return parseFloat sumPercentage.toFixed(2)

  ##################################
  # PUBLIC METHODS                 #
  ##################################

  calculateOrdersVariation: (ordersArray) ->
    ordersHealth = "0"

    ordersToCalculate = []

    for i in [0..5]
      ordersToCalculate[i] = ordersArray[i]

    ordersAverage = _weightedAverage ordersToCalculate

    percentToMinusThree = _calculatePercentage ordersAverage, ordersArray[2]
    percentToMinusFour = _calculatePercentage ordersAverage, ordersArray[3]
    percentToMinusFive = _calculatePercentage ordersAverage, ordersArray[4]
    percentToMinusTen = _calculatePercentage ordersAverage, ordersArray[5]

    variationsSum = _calculateVariation [percentToMinusThree, percentToMinusFour, percentToMinusFive, percentToMinusTen]

    return variationsSum

  calculateOrdersHealth: (orderVariation) ->

    # Health Calc: f(x) = 0.33 * x + 90
    ordersHealth = ( orderVariation / 3 ) + 90

    ordersHealth = 0 if ordersHealth < 0
    ordersHealth = 100 if ordersHealth > 100

    return parseFloat ordersHealth.toFixed(2)


instance = new HealthCalculator()
module.exports = instance