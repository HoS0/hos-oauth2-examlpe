mongoose = require('mongoose')

schema =
    name: String
    description: String
    threadId: String

model = null
if mongoose.models.Episode
  model = mongoose.model('Episode');
else
  model =  mongoose.model('Episode', new mongoose.Schema(schema));

module.exports = model
