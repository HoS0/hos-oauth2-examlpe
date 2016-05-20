contract    = require './contract'
HoSCom      = require 'hos-com'
mongoose    = require 'mongoose'

User                = require './controller/user'
Client              = require './controller/client'
Refereshtoken       = require './controller/refereshtoken'
Authorizationcode   = require './controller/authorizationcode'
Accesstoken         = require './controller/accesstoken'

amqpurl         = process.env.AMQP_URL ? "localhost"
amqpusername    = process.env.AMQP_USERNAME ? "guest"
amqppassword    = process.env.AMQP_PASSWORD ? "guest"
mongooseurl     = process.env.DB_URL ? "mongodb://dadiuser:t12345678@ds025232.mlab.com:25232"

if !mongoose.connection.db
    mongoose.connect(mongooseurl + '/dadidb', (err)-> console.log err)

module.exports =
    class ZettaboxAdmin
        hos = null
        constructor: ()->
            @hos = new HoSCom contract, amqpurl, amqpusername, amqppassword

            @hos.on '/user.get', (msg)=>
                try
                    if msg.properties.headers.query and msg.properties.headers.query.username and msg.properties.headers.query.password
                        op =
                            username: msg.properties.headers.query.username
                            password: msg.properties.headers.query.password
                        User.getOne(op).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                    else
                        id = msg.properties.headers.taskId
                        throw 'no id has provided' if !id
                        User.getOne({_id: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/user.post', (msg)=>
                try
                    User.create(msg.content).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/client.get', (msg)=>
                try
                    if msg.properties.headers.query and msg.properties.headers.query.clientId and msg.properties.headers.query.clientSecret
                        op =
                            clientId: msg.properties.headers.query.clientId
                            clientSecret: msg.properties.headers.query.clientSecret

                        Client.getOne(op).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                    else
                        id = msg.properties.headers.taskId
                        throw 'no id has provided' if !id
                        Client.getOne({clientId: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/client.post', (msg)=>
                try
                    Client.create(msg.content).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()




            @hos.on '/refereshtoken.get', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    Refereshtoken.getOne({token: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/refereshtoken.post', (msg)=>
                try
                    Refereshtoken.create(msg.content).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/refereshtoken.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    Refereshtoken.delete({token: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()



            @hos.on '/authorizationcode.get', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    Authorizationcode.getOne({code: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/authorizationcode.post', (msg)=>
                try
                    Authorizationcode.create(msg.content).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/authorizationcode.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    Authorizationcode.delete({code: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()



            @hos.on '/accesstoken.get', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    Accesstoken.getOne({token: id}).then((data)-> msg.reply(data)).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/accesstoken.post', (msg)=>
                try
                    Accesstoken.create(msg.content).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()

            @hos.on '/accesstoken.delete', (msg)=>
                try
                    id = msg.properties.headers.taskId
                    throw 'no id has provided' if !id
                    Accesstoken.delete({token: id}).then(()-> msg.reply({succeed: true})).catch((err)-> msg.reject())
                catch e
                    msg.reject()



        connect: ()->
            @hos.connect()

        destroy: ()->
            @hos.destroy()
