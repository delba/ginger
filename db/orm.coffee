fs   = require 'fs'
path = require 'path'

file = path.join(__dirname, 'videos.json')

exports.store = (json) ->
  fs.writeFile file, JSON.stringify(json), (err) ->
    throw err if err
    console.log 'saved!'

