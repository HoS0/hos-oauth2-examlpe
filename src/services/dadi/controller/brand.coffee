Brand = require '../model/brand'
Promise = require 'bluebird'
StoryController = require './story'
async = require('async')

exports.create = (obj)->
    return new Promise (fulfill, reject)=>
        ins = new Brand();
        ins.name = obj.name;
        ins.description = obj.name;

        ins.save (err, data)=>
            return reject(err) if err
            return fulfill(data)

exports.getOne = (option)->
    return new Promise (fulfill, reject)=>
        Brand.findOne(option).lean().exec (err, data)=>
            return reject(err) if err
            return fulfill(data) if !data or !data._id
            StoryController.get ({brandId: data._id})
            .then (stories)=>
                data.stories = stories
                return fulfill(data)
            .catch (err)=>
                return reject(err)

exports.get = (option)->
    return new Promise (fulfill, reject)=>
        Brand.find(option).lean().exec (err, data)=>
            return reject(err) if err
            promisses = []
            async.forEachSeries data, (d, callback)=>
                p = StoryController.get ({brandId: d._id})
                promisses.push p
                p.then (stories)=>
                    d.stories = stories
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
        Brand.update option, to, (err, num, raw)=>
            return reject(err) if err
            return fulfill({num: num, raw: raw})

exports.delete = (option)->
    return new Promise (fulfill, reject)=>
        Brand.remove option, (err)=>
            return reject(err) if err
            return fulfill()
