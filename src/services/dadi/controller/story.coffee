Story = require '../model/story'
Promise = require 'bluebird'
ThreadController = require './thread'
async = require('async')

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Story();
        ins.name = obj.name;
        ins.description = obj.name;
        ins.brandId = obj.brandId;

        ins.save (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Story.findOne(option).lean().exec (err, data)=>
            return reject(err) if err
            return fulfill(data) if !data or !data._id
            ThreadController.get ({storyId: data._id})
            .then (threads)=>
                data.threads = threads
                return fulfill(data)
            .catch (err)=>
                return reject(err)

exports.get = (option)->
    return new Promise (fulfill, reject)=>
        Story.find(option).lean().exec (err, data)=>
            return reject(err) if err
            promisses = []
            async.forEachSeries data, (d, callback)=>
                p = ThreadController.get ({storyId: d._id})
                promisses.push p
                p.then (threads)=>
                    d.threads = threads
                    callback()
                p.catch (e)=>
                    callback()

            Promise.all(promisses)
            .then ()->
                return fulfill(data)
            .catch (err)->
                return reject(err)

exports.update = (option, to)->
    return new Promise (fulfill, reject)=>
        Story.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Story.remove option, (err)=>
            return reject(err) if err
            return fulfill()
