# GET home page.
exports.index = (req, res) ->
  res.render('index')

exports.sessions = require './sessions'
exports.projects = require './projects'
