Authorizationcode = require '../model/authorizationcode'
Promise = require 'bluebird'

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Authorizationcode();
        ins.code = obj.code
        ins.clientID = obj.clientID
        ins.redirectURI = obj.redirectURI
        ins.userID = obj.userID
        ins.scope = obj.scope

        ins.save (err)=>
            return reject(err) if err
            return fulfill()

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Authorizationcode.findOne option, (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.update = (option, to)->
    return new Promise (fulfill, reject)=>
        Authorizationcode.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Authorizationcode.remove option, (err)=>
            return reject(err) if err
            return fulfill()
