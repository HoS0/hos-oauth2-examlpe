'use strict'
path = require('path')
passport = require('passport')
login = require('connect-ensure-login')

exports.loginForm = (req, res) ->
  res.sendFile path.join(__dirname, '../views/login.html')
  return

exports.login = [ passport.authenticate('local',
  successReturnToOrRedirect: '/'
  failureRedirect: '/login') ]

exports.logout = (req, res) ->
  req.logout()
  res.redirect '/'
  return

exports.account = [
  login.ensureLoggedIn()
  (req, res) ->
    res.render 'account', user: req.user
    return
]
exports.mamad = [
  passport.authenticate('bearer', session: false)
  (req, res) ->
    res.send 'so secret stuff'
    return
]
