fs = require 'fs'
path = require 'path'
CSON = require 'cson-safe'
podcastgen = require './podcastgen'

module.exports = run: ->
  throw 'no input file specified' unless process.argv[2]

  filepath = process.argv[2]

  parser = if path.extname(filepath) == '.cson' then CSON else JSON

  process.stdout.write podcastgen parser.parse fs.readFileSync filepath
