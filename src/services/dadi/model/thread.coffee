mongoose = require('mongoose')

schema =
    name: String
    description: String
    storyId: String

model = null
if mongoose.models.Thread
  model = mongoose.model('Thread');
else
  model =  mongoose.model('Thread', new mongoose.Schema(schema));

module.exports = model
