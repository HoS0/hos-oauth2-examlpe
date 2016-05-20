mongoose = require('mongoose')

schema =
    code: String
    clientID: String
    redirectURI: String
    userID: String
    scope: String

model = null
if mongoose.models.Authorizationcode
  model = mongoose.model('Authorizationcode');
else
  model =  mongoose.model('Authorizationcode', new mongoose.Schema(schema));

module.exports = model
