'use strict'
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
BasicStrategy = require('passport-http').BasicStrategy
ClientPasswordStrategy = require('passport-oauth2-client-password').Strategy
BearerStrategy = require('passport-http-bearer').Strategy
config = require('./config')

module.exports = (hos)->
    passport.use new LocalStrategy (username, password, done) ->
        hos.sendMessage({} , '/user', {task: '/user', method: 'get', query: {username: username, password: password}})
        .then (user)=>
            if user
                return done(null, user)
            return done(null, false)
        .catch (e)=>
            return done(null)

    passport.use new BasicStrategy (username, password, done) ->
        hos.sendMessage({} , '/user', {task: '/client', method: 'get', query: {clientId: username, clientSecret: password}})
        .then (client)=>
            if client
                return done(null, client)
            return done(null, false)
        .catch (e)=>
            return done(null)

    passport.use new ClientPasswordStrategy (clientId, clientSecret, done) ->
        hos.sendMessage({} , '/user', {task: '/client', method: 'get', query: {clientId: username, clientSecret: password}})
        .then (client)=>
            if client
                return done(null, client)
            return done(null, false)
        .catch (e)=>
            return done(null)

    passport.use new BearerStrategy (accessToken, done) ->
        hos.sendMessage({} , '/user', {task: '/accesstoken', method: 'get', taskId: accessToken})
        .then (token)=>
            if !token
                return done(null, false)
            if new Date > token.expirationDate
                hos.sendMessage({} , '/user', {task: '/accesstoken', method: 'delete', taskId: accessToken}).then(()=>return done(null, false)).catch((e)=>return done('unauthorize'))
            else
                if token.userID != null
                    hos.sendMessage({} , '/user', {task: '/user', method: 'get', taskId: token.userID})
                    .then (user)=>
                        throw 'user not found' if !user
                        return done null, user, {scope:'*'}
                    .catch (e)=>
                        return done('unauthorize')
                else
                    hos.sendMessage({} , '/user', {task: '/client', method: 'get', taskId: token.clientID})
                    .then (client)=>
                        throw 'client not found' if !client
                        return done null, client, {scope:'*'}
                    .catch (e)=>
                        return done('unauthorize')
        .catch (e)=>
            return done('unauthorize')

    passport.serializeUser (user, done) ->
        return done null, user._id if user._id
        return done null

    passport.deserializeUser (id, done) ->
        hos.sendMessage({} , '/user', {task: '/user', method: 'get', taskId: id})
        .then (u)=>
            done null, u
        .catch (e)=>
            done e
