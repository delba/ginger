fs = require 'fs'
qs = require 'querystring'

Video = require('../models/video')

class VideosController
  constructor: (@req, @res) ->

  index: ->
    html = fs.createReadStream('index.html')
    html.pipe @res

  create: ->
    body = ''
    @req.on 'data', (chunk) -> body += chunk
    @req.on 'end', =>
      params = qs.parse(body)
      video = new Video(params, this)
      video.save ->
        console.log video.html
        @index()

module.exports = VideosController
