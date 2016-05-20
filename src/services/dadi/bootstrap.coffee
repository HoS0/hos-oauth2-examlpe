contract    = require './contract'
HoSCom      = require 'hos-com'
mongoose    = require 'mongoose'

brand       = require './controller/brand'
episode     = require './controller/episode'
story       = require './controller/story'
thread      = require './controller/thread'

amqpurl         = process.env.AMQP_URL ? "localhost"
amqpusername    = process.env.AMQP_USERNAME ? "guest"
amqppassword    = process.env.AMQP_PASSWORD ? "guest"
mongooseurl     = process.env.DB_URL ? "mongodb://dadiuser:t12345678@ds025232.mlab.com:25232"

if !mongoose.connection.db
    mongoose.connect mongooseurl + '/dadidb'

module.exports =
    class ZettaboxAdmin
        hos = null
        constructor: ()->
            @hos = new HoSCom contract, amqpurl, amqpusername, amqppassword

            @hos.on '/brand.get', (msg)=>
                try
                    if msg.properties.headers.query and msg.properties.headers.query.name
                        op =
                            name: msg.properties.headers.query.name
                        brand.getOne(op).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                    else
                        id = msg.properties.headers.taskId
                        throw 'no id has provided' if !id
                        brand.getOne({_id: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/brand.post', (msg)=>
                try
                    brand.create(msg.content).then((d)-> msg.reply(d)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/brand.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    brand.delete({_id: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()


            @hos.on '/story.get', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    story.getOne({_id: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/story.post', (msg)=>
                try
                    story.create(msg.content).then((d)-> msg.reply(d)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/story.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    story.delete({_id: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()


            @hos.on '/thread.get', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    thread.getOne({_id: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/thread.post', (msg)=>
                try
                    thread.create(msg.content).then((d)-> msg.reply(d)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/thread.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    thread.delete({_id: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/episode.get', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    episode.getOne({_id: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/episode.post', (msg)=>
                try
                    episode.create(msg.content).then((d)-> msg.reply(d)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/episode.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    episode.delete({_id: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()


        connect: ()->
            @hos.connect()

        destroy: ()->
            @hos.destroy()
