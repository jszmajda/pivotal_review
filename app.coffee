# Module dependencies
express = require("express")
routes = require("./routes")
global._ = require 'underscore'
global.AppConfig = require('./settings').value

RedisStore = require('connect-redis')(express);
require './models'

app = module.exports = express.createServer()

# Configuration
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.logger()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session({secret: '4p9382714dn24', store: new RedisStore})
  app.use express.methodOverride()
  app.use (req,res,next) ->
    if req.body.token
      req.session.token = req.body.token

    if req.session and req.session.token
      global.pivotal = require('pivotal')
      global.pivotal.useToken req.session.token
    next()

  app.use require('connect-assets')()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

# Routes
app.get "/", routes.index
app.post "/sessions/new", routes.sessions.new
app.get "/projects", routes.projects.index
app.get "/projects/:id", routes.projects.show
app.get "/projects/:id/rate", routes.projects.rate

app.dynamicHelpers
  flash: (req, res) ->
    req.flash()
app.helpers
  story_type_icon: (story_type) ->
    'https://cdn1-pivotaltracker.pantherssl.com/images/v7/application/stories_view/icons/' + story_type + '.png'
  story_size_icon: (estimate) ->
    'https://cdn2-pivotaltracker.pantherssl.com/images/v7/application/stories_view/icons/estimate_' + estimate + 'pt_powers_of_2.gif'


app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
