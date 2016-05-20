mongoose = require('mongoose')

schema =
    name: String
    description: String

model = null
if mongoose.models.Brand
  model = mongoose.model('Brand');
else
  model =  mongoose.model('Brand', new mongoose.Schema(schema));

module.exports = model
