mongoose = require('mongoose')

schema =
    username: String
    password: String
    name: String

model = null
if mongoose.models.User
  model = mongoose.model('User');
else
  model =  mongoose.model('User', new mongoose.Schema(schema));

module.exports = model
