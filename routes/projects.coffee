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
      stories = _(data.iteration).chain().map((i) -> i.stories.story).flatten().value()

    res.render('projects/show', {stories: stories})
