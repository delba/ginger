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
        for key, value of JSON.parse(body)
          this[key] = value
        callback.apply @_controller

module.exports = Video
