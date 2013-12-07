http = require 'http'
url  = require 'url'

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

module.exports = Video
