exports.new = (req,res) ->
  global.pivotal.getProjects (e, data) ->
    if e
      req.flash('error', 'Invalid API Token')
      res.redirect('back')
    else
      req.flash('info', 'Login Successful')
      res.redirect('/projects')

