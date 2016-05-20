'use strict'
oauth2orize = require('oauth2orize')
passport = require('passport')
login = require('connect-ensure-login')
config = require('./config')
server = oauth2orize.createServer()
hos = {}

exports.init = (hosapi)->
    hos = hosapi;

uid = (len) ->
  buf = []
  chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  charlen = chars.length
  i = 0
  while i < len
    buf.push chars[getRandomInt(0, charlen - 1)]
    ++i
  buf.join ''

getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

renderForm = (input) ->
  '<form action="/dialog/authorize/decision" method="post" class="pure-form pure-form-stacked"><input name="transaction_id" type="hidden" value="' + input.transactionID + '"><fieldset><div class="upper-box"><div><div class="main-text">Decision</div><div class="subtext">Authorization Server</div></div><div class="pure-control-group labels"><p><p>' + input.user.name + ',</p>The application <b>' + input.client.name + '</b> is requesting access to your account.<p>Do you approve?</p></p></div></div><div class="bottom-box"><div class="pure-controls accept-cancel-buttons"><div><input class="pure-button pure-button-primary" type="submit" value="Accept" id="allow"><span>&nbsp&nbsp</span><input class="pure-button" type="submit" value="Deny" name="cancel" id="deny"></div></div></div></fieldset></form>'

server.grant oauth2orize.grant.code (client, redirectURI, user, ares, done) ->
    authcode =
        code: uid(config.token.authorizationCodeLength)
        clientID: client.clientId
        redirectURI: redirectURI
        userID: user._id
        scope: client.scope

    hos.sendMessage(authcode , '/user', {task: '/authorizationcode', method: 'post'})
    .then(()=>return done(null, authcode.code);)
    .catch((e)=>return done(e.reason))


server.grant oauth2orize.grant.token (client, user, ares, done) ->
    acctoken =
        token: uid(config.token.accessTokenLength)
        userID: user._id
        expirationDate: config.token.calculateExpirationDate()
        clientID: client.clientId
        scope: client.scope

    hos.sendMessage(acctoken , '/user', {task: '/accesstokens', method: 'post'})
    .then(()=>return done(null, acctoken.token, acctoken.expirationDate);)
    .catch((e)=>return done(e.reason))

server.exchange oauth2orize.exchange.code (client, code, redirectURI, done) ->
    hos.sendMessage({} , '/user', {task: '/authorizationcode', method: 'get', taskId: code})
    .then (authCode)=>
        if !authCode or client.clientId != authCode.clientID or redirectURI != authCode.redirectURI
            return done(null, false)

        hos.sendMessage({} , '/user', {task: '/authorizationcode', method: 'delete', taskId: code})
        .then ()=>
            acctoken =
                token: uid(config.token.accessTokenLength)
                userID: authCode.userID
                expirationDate: config.token.calculateExpirationDate()
                clientID: authCode.clientID
                scope: authCode.scope

            hos.sendMessage(acctoken , '/user', {task: '/accesstoken', method: 'post'})
            .then ()=>
                refreshToken = null
                if authCode.scope and authCode.scope.indexOf('offline_access') == 0
                    refreshToken =
                        token: uid(config.token.accessTokenLength)
                        userID: authCode.userID
                        clientID: authCode.clientID
                        scope: authCode.scope

                    hos.sendMessage(refreshToken , '/user', {task: '/refereshtoken', method: 'post'})
                    .then ()=>
                        return done(null, acctoken.token, refreshToken, expires_in: config.token.expiresIn)
                    .catch (e)=> return done(e.reason)
                else
                    return done(null, acctoken.token, refreshToken, expires_in: config.token.expiresIn)
            .catch (e)=> return done(e.reason)
        .catch (e)=> return done(e.reason)
    .catch (e)=> return done(e.reason)


server.exchange oauth2orize.exchange.password (client, username, password, scope, done) ->
    hos.sendMessage({} , '/user', {task: '/user', method: 'get', query: {username: username, password: password}})
    .then (user)=>
        if !user
            return done(null, false)

        acctoken =
            token: uid(config.token.accessTokenLength)
            userID: user._id
            expirationDate: config.token.calculateExpirationDate()
            clientID: client.id
            scope: scope

        hos.sendMessage(acctoken , '/user', {task: '/accesstokens', method: 'post'})
        .then ()=>
            refreshToken = null
            if authCode.scope and authCode.scope.indexOf('offline_access') == 0
                refreshToken =
                    token: uid(config.token.accessTokenLength)
                    userID: user._id
                    clientID: client.id
                    scope: scope

                hos.sendMessage(refreshToken , '/user', {task: '/refereshtoken', method: 'post'})
                .then ()=>
                    return done(null, token, refreshToken, expires_in: config.token.expiresIn)
                .catch (e)=> return done(e.reason)
            else
                return done(null, token, refreshToken, expires_in: config.token.expiresIn)
        .catch (e)=> return done(e.reason)
    .catch (e)=> return done(e.reason)

server.exchange oauth2orize.exchange.clientCredentials (client, scope, done) ->
    acctoken =
        token: uid(config.token.accessTokenLength)
        userID: null
        expirationDate: config.token.calculateExpirationDate()
        clientID: client.id
        scope: scope

    hos.sendMessage(acctoken , '/user', {task: '/accesstokens', method: 'post'})
    .then ()=> done null, acctoken.token, null, expires_in: config.token.expiresIn
    .catch (e)=> return done(e.reason)


server.exchange oauth2orize.exchange.refreshToken (client, refreshToken, scope, done) ->
    hos.sendMessage({} , '/user', {task: '/refereshtoken', method: 'get', taskId: refreshToken})
    .then (authCode)=>
        if !authCode
            return done(null, false)
        acctoken =
            token: uid(config.token.accessTokenLength)
            userID: authCode.userID
            expirationDate: config.token.calculateExpirationDate()
            clientID: authCode.clientID
            scope: authCode.scope

        hos.sendMessage(acctoken , '/user', {task: '/accesstokens', method: 'post'})
        .then ()=> done null, acctoken.token, null, expires_in: config.token.expiresIn
        .catch (e)=> return done(e.reason)
    .catch (e)=> return done(e.reason)

exports.authorization = [
    login.ensureLoggedIn()
    server.authorization((clientID, redirectURI, scope, done) ->
        hos.sendMessage({} , '/user', {task: '/client', method: 'get', taskId: clientID})
        .then (client)=>
            return done('client not found') if !client
            client.scope = scope if client
            done null, client, redirectURI
        .catch (e)=> done(e.reason)

        return
    )
    (req, res, next) ->
        hos.sendMessage({} , '/user', {task: '/client', method: 'get', taskId: req.query.client_id})
        .then (client)=>
            if client and client.trustedClient and client.trustedClient == true
                server.decision({ loadTransaction: false }, (req, callback) ->
                    callback null, allow: true
                    return
                ) req, res, next
            else
                res.send renderForm(
                    transactionID: req.oauth2.transactionID
                    user: req.user
                    client: req.oauth2.client)
        .catch ()=>
            res.send renderForm(
                transactionID: req.oauth2.transactionID
                user: req.user
                client: req.oauth2.client)
]
exports.decision = [
    login.ensureLoggedIn()
    server.decision()
]
exports.token = [
    passport.authenticate([
        'basic'
        'oauth2-client-password'
    ], session: false)
    server.token()
    server.errorHandler()
]
server.serializeClient (client, done) ->
    done null, client.clientId

server.deserializeClient (id, done) ->
    hos.sendMessage({} , '/user', {task: '/client', method: 'get', taskId: id})
    .then (u)=>
        done null, u
    .catch (e)=>
        done e
