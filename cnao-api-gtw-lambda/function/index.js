//APPD - ADD TRACER
//const tracer = require('appdynamics-lambda-tracer')

const AWS = require('aws-sdk')
// Create client outside of handler to reuse
const lambda = new AWS.Lambda()

//APPD - Initialize the tracer
//tracer.init();

// Handler
exports.handler = async function(event, context) {
  console.log('## ENVIRONMENT VARIABLES: ' + serialize(process.env))
  console.log('## CONTEXT: ' + serialize(context))
  console.log('## EVENT: ' + serialize(event))
  try {
    let accountSettings = await getAccountSettings()
    return formatResponse("{\"atms\": [{\"atmLocation\": {\"address\": {\"city\": \"ISLANDIA\", \"country\": \"USA\", \"postalCode\": \"14758\", \"state\": \"NY\", \"street\": \"1700 VETERANS HIGHWAY\"}, \"coordinates\": {\"latitude\": 40.805604, \"longitude\": -73.181343 }, \"id\": \"848936\", \"isAvailable24Hours\": true, \"isDepositAvailable\": false, \"isHandicappedAccessible\": false, \"isOffPremise\": true, \"isSeasonal\": false, \"languageType\": null, \"locationDescription\": \"1700 VETERANS HIGHWAY,ISLANDIA,NY,14758,USA\", \"logoName\": \"711\", \"name\": \"7ELEVEN-FCTI\"}, \"distance\": 0.5843634867457268 }, {\"atmLocation\": {\"address\": {\"city\": \"COLORADO\", \"country\": \"USA\", \"postalCode\": \"14758\", \"state\": \"DN\", \"street\": \"12551 HWY 24 HARTSEL\"}, \"coordinates\": {\"latitude\": 39.0214828, \"longitude\": -105.8002834 }, \"id\": \"848936\", \"isAvailable24Hours\": true, \"isDepositAvailable\": false, \"isHandicappedAccessible\": false, \"isOffPremise\": true, \"isSeasonal\": false, \"languageType\": null, \"locationDescription\": \"12551 HWY 24 HARTSEL,COLORADO,DN,14758,USA\", \"logoName\": \"711\", \"name\": \"BADGER BASIN\"}, \"distance\": 3.57 }, {\"atmLocation\": {\"address\": {\"city\": \"COLORADO\", \"country\": \"USA\", \"postalCode\": \"14758\", \"state\": \"DN\", \"street\": \"8722 TELLER HWY NO 1 FLORISSANT\"}, \"coordinates\": {\"latitude\": 38.8213947, \"longitude\": -105.2608944 }, \"id\": \"848936\", \"isAvailable24Hours\": true, \"isDepositAvailable\": false, \"isHandicappedAccessible\": false, \"isOffPremise\": true, \"isSeasonal\": false, \"languageType\": null, \"locationDescription\": \"8722 TELLER HWY NO 1 FLORISSANT,COLORADO,DN,14758,USA\", \"logoName\": \"711\", \"name\": \"ATM TECHNOLOGIES\"}, \"distance\": 6.85 } ], \"atms_count\": 3, \"error_code\": \"0\", \"http_code\": \"200\", \"limit\": 3, \"page\": 1, \"page_count\": 1, \"success\": true }")
    //return formatResponse(serialize(accountSettings.AccountUsage))
  } catch(error) {
    return formatError(error)
  }
}

var formatResponse = function(body){
  var response = {
    "statusCode": 200,
    "headers": {
      "Content-Type": "application/json"
    },
    "isBase64Encoded": false,
    "multiValueHeaders": { 
      "X-Custom-Header": ["My value", "My other value"],
    },
    "body": body
  }
  return response
}

var formatError = function(error){
  var response = {
    "statusCode": error.statusCode,
    "headers": {
      "Content-Type": "text/plain",
      "x-amzn-ErrorType": error.code
    },
    "isBase64Encoded": false,
    "body": error.code + ": " + error.message
  }
  return response
}
// Use SDK client
var getAccountSettings = function(){
  return lambda.getAccountSettings().promise()
}

var serialize = function(object) {
  return JSON.stringify(object, null, 2)
}

//APPD - Complete the instrumentation
//tracer.mainModule(module);
