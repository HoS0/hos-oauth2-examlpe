mongoose = require('mongoose')

schema =
    name: String
    clientId: String
    clientSecret: String
    trustedClient: String

model = null
if mongoose.models.Client
  model = mongoose.model('Client');
else
  model =  mongoose.model('Client', new mongoose.Schema(schema));

module.exports = model
