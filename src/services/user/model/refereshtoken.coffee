mongoose = require('mongoose')

schema =
    token: String
    userID: String
    clientID: String
    scope: String

model = null
if mongoose.models.Refereshtoken
  model = mongoose.model('Refereshtoken');
else
  model =  mongoose.model('Refereshtoken', new mongoose.Schema(schema));

module.exports = model
