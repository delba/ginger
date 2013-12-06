fs   = require 'fs'
qs   = require 'querystring'
url  = require 'url'
http = require 'http'

server = http.createServer()

class Video
  @endpoints =
    'vimeo.com': 'http://vimeo.com/api/oembed.json',
    'youtube.com': 'http://www.youtube.com/oembed',
    'dailymotion.com': 'http://www.dailymotion.com/services/oembed'

  constructor: (params, @_controller) ->
    @url = params.url
    @endpoint = Video.endpoints[url.parse(@url).hostname]
    @oembed_url = "#{@endpoint}?url=#{@url}"

  save: (callback) ->
    http.get @oembed_url, (res) =>
      body = ''
      res.on 'data', (chunk) -> body += chunk
      res.on 'end', =>
        json = JSON.parse(body)
        @provider_name = json.provider_name
        @title = json.title
        @author_name = json.author_name
        @author_url = json.author_url
        @html = json.html
        @width = json.width
        @height = json.height
        @duration = json.duration
        @description = json.description
        @thumbnail_url = json.thumbnail_url
        @thumbnail_width = json.width
        @thumbnail_height = json.height
        @video_id = json.video_id
        callback.apply @_controller

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

server.on 'request', (req, res) ->
  if req.url is '/'
    controller = new VideosController(req, res)

    switch req.method
      when 'GET'  then controller.index()
      when 'POST' then controller.create()

server.listen 8080

