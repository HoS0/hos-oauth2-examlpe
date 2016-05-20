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
        @serviceRequester.sendMessage({} , '/user', {task: '/user', method: 'get', query: {username: "test", password: "laksdj"}})
        .then (replyPayload)=>
            done()
        .catch (e)=>
            console.log e

    it "and it should get client", (done)->
        @serviceRequester.sendMessage({} , '/user', {task: '/authorizationcode', method: 'delete', taskId: 'w8JH13E7ZI8Mrcs2'})
        .then (replyPayload)=>
            done()
        .catch (e)=>
            console.log e

        # hos.sendMessage({} , '/user', {task: '/authorizationcode', method: 'delete', taskId: code})
        # .then ()=>
