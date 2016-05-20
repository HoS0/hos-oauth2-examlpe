Thread = require '../model/thread'
Promise = require 'bluebird'
EpisodeController = require './episode'
async = require('async')

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Thread();
        ins.name = obj.name;
        ins.description = obj.name;
        ins.storyId = obj.storyId;

        ins.save (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Thread.findOne(option).lean().exec (err, data)=>
            return reject(err) if err
            return fulfill(data) if !data or !data._id
            EpisodeController.get ({threadId: data._id})
            .then (episodes)=>
                data.episodes = episodes
                return fulfill(data)
            .catch (err)=>
                return reject(err)

exports.get = (option)->
    return new Promise (fulfill, reject)=>
        Thread.find(option).lean().exec (err, data)=>
            return reject(err) if err
            promisses = []
            async.forEachSeries data, (d, callback)=>
                p = EpisodeController.get ({threadId: d._id})
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
        Thread.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Thread.remove option, (err)=>
            return reject(err) if err
            return fulfill()
