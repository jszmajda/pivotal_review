fs = require 'fs'

exports.index = (req, res) ->
  global.pivotal.getProjects (e, data) ->
    projects = []
    if e
      req.flash('error', 'Error talking to Pivotal, please reload')
    else
      projects = data.project

    res.render('projects/index', { projects: projects })

exports.show = (req, res) ->
  global.pivotal.getIterations req.params.id, {group: 'done', offset: -5}, (e, data) ->
    stories = []
    if e
      req.flash('error', 'Error talking to Pivotal, please reload')
    else
      stories = _(data.iteration).chain().map((i) -> i.stories.story).flatten().shuffle().value().slice(0,AppConfig.num_stories)

    res.render('projects/show', {stories: stories, project_id: req.params.id})

#exports.show = (req, res) ->
#  fs.readFile '/tmp/stories.out', (e,data) ->
#    stories = []
#    if e
#      req.flash('error', 'Error talking to Pivotal, please reload')
#    else
#      stories = JSON.parse(data)

#    res.render('projects/show', {stories: stories, project_id: req.params.id})

exports.rate = (req, res) ->
  Story.rate(
    req.session.token,
    req.query.story,
    req.query.rating,
    (e) ->
      if e
        req.end 'ERR'
      else
        res.end 'OK'
  )
