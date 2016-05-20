Promise         = require 'bluebird'
HosCom          = require 'hos-com'
HoSAuth         = require 'hos-auth'
crypto          = require 'crypto'
Service         = require '../bootstrap'
generalContract = require './serviceContract'

amqpurl     = process.env.AMQP_URL ? "localhost"
username    = process.env.AMQP_USERNAME ? "guest"
password    = process.env.AMQP_PASSWORD ? "guest"

describe "Check basic operations", ()->
    beforeEach (done)->
        @service = new Service()

        @serviceCon = JSON.parse(JSON.stringify(generalContract))
        @serviceCon.serviceDoc.basePath = "serviceTest#{crypto.randomBytes(4).toString('hex')}"
        @serviceRequester = new HosCom @serviceCon, amqpurl, username, password

        @hosAuth = new HoSAuth(amqpurl, username, password)
        promisses = []
        promisses.push @hosAuth.connect()
        promisses.push @service.connect()
        promisses.push @serviceRequester.connect()

        Promise.all(promisses).then ()=>
            @hosAuth.on 'message', (msg)=>
                msg.accept()

            done()

    afterEach ()->
        @service.destroy()
        @serviceRequester.destroy()
        @hosAuth.destroy()

    it "and it should get users", (done)->
        done()
