express     = require('express')
http        = require('http')
bodyParser  = require('body-parser')
hosApi      = require('hos-api')
HoSAuth     = require('hos-auth')
cors        = require('cors')
path        = require('path')
Promise     = require('bluebird')
passport        = require('passport')
cookieParser    = require('cookie-parser')
expressSession  = require("express-session")

UserService = require('./services/user')
DadiService = require('./services/dadi')
promisses = [UserService, DadiService]

site    = require('./site')
config  = require('./config')

amqpurl     = process.env.AMQP_URL ? "localhost"
amqpusername    = process.env.AMQP_USERNAME ? "guest"
amqppassword    = process.env.AMQP_PASSWORD ? "guest"

sessionStorage = new expressSession.MemoryStore();
sessionOptions =
    saveUninitialized: true
    resave: true
    secret: config.session.secret
    store: sessionStorage
    key: "authorization.sid"
    cookie:
        maxAge: config.session.maxAge

hosAuth = new HoSAuth(amqpurl, amqpusername, amqppassword)
hosAuth.on 'message', (msg) ->
  msg.accept()

port = process.env.PORT || 8080
address = process.env.API_ADDRESS ? 'localhost'

Promise.all(promisses).then ->
    hosAuth.connect().then ->
        hosApi.init(true, "#{address}:8080").then ->
            app = express()

            app.set 'view engine', 'ejs'
            app.set 'port', port
            app.use cors()
            app.use cookieParser()
            app.use expressSession(sessionOptions)
            app.use bodyParser.urlencoded({extended: true})
            app.use bodyParser.json()
            app.use passport.initialize()
            app.use passport.session()
            app.use express.static(path.join(__dirname, '../public'))

            oauth2  = require('./oauth2')
            oauth2.init hosApi
            require('./auth')(hosApi)

            app.get '/login', site.loginForm
            app.post '/login', site.login
            app.get '/logout', site.logout
            app.get '/account', site.account
            app.get '/mamad', site.mamad

            app.get '/dialog/authorize', oauth2.authorization
            app.post '/dialog/authorize/decision', oauth2.decision
            app.post '/oauth/token', oauth2.token
            app.use hosApi.swaggerMetadata
            app.use hosApi.swaggerValidator
            app.all('/docs' ,[passport.authenticate('basic', session: false), hosApi.swaggerUi])
            app.all('/docs/*' ,[passport.authenticate('basic', session: false), hosApi.swaggerUi])
            app.all('/api-docs' ,[passport.authenticate('basic', session: false), hosApi.swaggerUi])

            app.all('/dadi/*' ,[passport.authenticate('bearer', session: false), hosApi.middleware])

            http.createServer(app).listen app.get('port'), ->
              console.log 'Express server listening on port ' + app.get('port')
              console.log 'try opening http://localhost:8080/docs/'
