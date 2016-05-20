Client = require '../model/client'
Promise = require 'bluebird'

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Client();
        ins.name = obj.name
        ins.clientId = obj.clientId
        ins.clientSecret = obj.clientSecret
        ins.trustedClient = obj.trustedClient

        ins.save (err)=>
            return reject(err) if err
            return fulfill()

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Client.findOne option, (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.update = (option, to)->
    return new Promise (fulfill, reject)=>
        Client.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Client.remove option, (err)=>
            return reject(err) if err
            return fulfill()
