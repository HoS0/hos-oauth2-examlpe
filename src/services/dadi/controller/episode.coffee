Episode = require '../model/episode'
Promise = require 'bluebird'

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Episode();
        ins.name = obj.name;
        ins.description = obj.name;
        ins.threadId = obj.threadId;

        ins.save (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Episode.findOne option, (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.get = (option)->
    return new Promise (fulfill, reject)=>
        Episode.find option, (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.update = (option, to)->
    return new Promise (fulfill, reject)=>
        Episode.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Episode.remove option, (err)=>
            return reject(err) if err
            return fulfill()
