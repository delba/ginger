http = require 'http'

Video = require('./models/video')
VideosController = require('./controllers/videos_controller')

server = http.createServer()

server.on 'request', (req, res) ->
  if req.url is '/'
    controller = new VideosController(req, res)

    switch req.method
      when 'GET'  then controller.index()
      when 'POST' then controller.create()

server.listen 8080

