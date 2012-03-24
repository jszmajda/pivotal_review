mg = require 'mongoose'
mg.connect('mongodb://localhost/pivotal_review')
global.mongoose = mg

require('./story')
