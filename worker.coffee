LIService = require './services/li'

ONE_MIN = 5 * 1000

queryAnalyzeAndAct = ->
  console.log 'Logging in to Splunk'

try
  # Run every minute
  setInterval queryAnalyzeAndAct, ONE_MIN
  # Run first time
  queryAnalyzeAndAct()
catch e
  console.error "Error!", e