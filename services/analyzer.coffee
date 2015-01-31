ss = require 'simple-statistics'
_ = require 'underscore'

class Analyzer
	constructor: (@numberOfTrendValues = 5) ->

	resultsToHealth: (results) ->
		throw new Error '"results" parameter is required' if not results?

		console.log 'Converting results to health object'
		rows = results.rows
		health =
			time: []
			orders: []
			latencies: []
			errors: []

		# Add -1m to root for easier plotting
		mostRecent = _.last(rows)
		health.m_time = mostRecent[0]
		health.m_orders = parseInt(mostRecent[1], 10)
		health.m_latencies = parseFloat(mostRecent[2])
		health.m_errors = parseInt(mostRecent[4], 10)

		for result in rows
			health.time.push result[0]
			health.orders.push parseInt(result[1], 10)
			health.latencies.push parseFloat(result[2])
			health.errors.push parseInt(result[4], 10)

		return health

	calculateLinearTrends: (health) =>
		throw new Error '"health" parameter is required' if not health?

		console.time 'Calculating order trend'
		health.ordersTrend = @getLinearTrend(health.orders)
		console.timeEnd 'Calculating order trend'

		console.time 'Calculating latency trend'
		health.latencyTrend = @getLinearTrend(health.latencies)
		console.timeEnd 'Calculating latency trend'

		console.time 'Calculating errors trend'
		health.errorsTrend = @getLinearTrend(health.errors)
		console.timeEnd 'Calculating errors trend'
		return health

	# Given array of values [1,2,3...]
	# Return {a: Integer, b: Integer, f: function} parameters from linear function y = ax + b
	getLinearTrend: (values) ->
		throw new Error '"values" parameter is required' if not values?

		linearRegressionSolver = ss.linear_regression()

		points = []
		for value, i in values
			points.push [i, value]

		linearRegressionSolver.data(points)

		# TODO trend = linearRegressionSolver.line(i) for i in [values.length .. values.length + @numberOfTrendValues]

		return {
			a: linearRegressionSolver.m()
			b: linearRegressionSolver.b()
		}

module.exports = Analyzer
