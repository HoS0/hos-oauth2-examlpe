mongoose = require('mongoose')

schema =
    token: String
    userID: String
    expirationDate: String
    clientID: String
    scope: String

model = null
if mongoose.models.Accesstoken
  model = mongoose.model('Accesstoken');
else
  model =  mongoose.model('Accesstoken', new mongoose.Schema(schema));

module.exports = model
