Promise         = require 'bluebird'
bodyParser      = require 'body-parser'
crypto          = require 'crypto'
HosCom          = require 'hos-com'
HoSAuth         = require 'hos-auth'
request         = require 'supertest'
express         = require 'express'
hosApi          = require 'hos-api'


amqpurl     = process.env.AMQP_URL ? "localhost"
username    = process.env.AMQP_USERNAME ? "guest"
password    = process.env.AMQP_PASSWORD ? "guest"

describe "Open express app", ()->
    beforeEach (done)->
        @hosAuth = new HoSAuth(amqpurl, username, password)
        UserService = require('../services/user')
        DadiService = require('../services/dadi')
        promisses = [@hosAuth.connect(), UserService, DadiService]
        Promise.all(promisses).then =>
            @hosAuth.on 'message', (msg)=>
                msg.accept()

            hosApi.init(true)
            .then =>
                done()

    afterEach (done)->
        hosApi.destroy()
        @hosAuth.destroy()
        done()

    it "GET /ctrlr/tasks", (done)->

        app = express()
        app.use bodyParser.urlencoded({extended: true})
        app.use bodyParser.json()
        app.use hosApi.middleware

        request(app)
        .get('/ctrlr/tasks?docincluded=true')
        .expect 200
        .end (err, res)=>
            if !err
                expect(typeof res.body.doc).toBe('object')
                done()

        return

    it "GET /dadi/brand?name=story1 ", (done)->
        app = express()
        app.use bodyParser.urlencoded({extended: true})
        app.use bodyParser.json()
        app.use hosApi.middleware

        request(app)
        .get('/dadi/brand?name=story1')
        .expect 200
        .end (err, res)=>
            if !err
                expect(res.body.description).toBe('story1')
                done()

        return
