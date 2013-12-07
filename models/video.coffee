fs   = require 'fs'
path = require 'path'
http = require 'http'
url  = require 'url'
orm  = require '../db/orm'

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

        orm.store json

        for key, value of json
          this[key] = value

        callback.apply @_controller

module.exports = Video
