Accesstoken = require '../model/accesstoken'
Promise = require 'bluebird'

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Accesstoken();
        ins.token = obj.token
        ins.userID = obj.userID
        ins.expirationDate = obj.expirationDate
        ins.clientID = obj.clientID
        ins.scope = obj.scope

        ins.save (err)=>
            return reject(err) if err
            return fulfill()

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Accesstoken.findOne option, (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.update = (option, to)->
    return new Promise (fulfill, reject)=>
        Accesstoken.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Accesstoken.remove option, (err)=>
            return reject(err) if err
            return fulfill()
