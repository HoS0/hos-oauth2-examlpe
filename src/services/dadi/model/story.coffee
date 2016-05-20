mongoose = require('mongoose')

schema =
    name: String
    description: String
    brandId: String

model = null
if mongoose.models.Story
  model = mongoose.model('Story');
else
  model =  mongoose.model('Story', new mongoose.Schema(schema));

module.exports = model
