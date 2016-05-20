/* jshint node:true */
'use strict';
require('coffee-script/register');

var Service = require('./bootstrap');
var service = new Service()

var p = service.connect();
module.exports = p
