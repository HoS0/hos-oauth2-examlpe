User = require '../model/user'
Promise = require 'bluebird'

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new User();
        ins.username = obj.username;
        ins.password = obj.password;
        ins.name = obj.name;

        ins.save (err)=>
            return reject(err) if err
            return fulfill()

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        User.findOne option, (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.update = (option, to)->
    return new Promise (fulfill, reject)=>
        User.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        User.remove option, (err)=>
            return reject(err) if err
            return fulfill()
