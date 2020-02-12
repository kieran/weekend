import React from 'react'

import { get } from 'axios'

export default \
class Gif extends React.Component
  constructor: ({name})->
    super arguments...
    @state = {}

    do =>
      # giphy setup
      url     = 'https://api.giphy.com/v1/gifs/search'
      api_key = '02c86584244447a3884c4a867d36932b'
      q       = (name or 'work sad').replace /\s/g, '+'
      limit   = 10

      # get gifs
      { data: data: gifs } = await get url, params: { q, api_key, limit }

      # fetch a random result
      gif = gifs[Math.floor Math.random() * gifs.length]

      {
        original: { mp4, webp }
        original_still: { url: poster }
      } = gif.images

      @setState { mp4, webp, poster }

  render: ->
    { mp4, webp, poster } = @state
    return null unless poster
    <div className="Gif">
      <video loop={true} muted={true} autoPlay={true} poster={poster}>
        <source src={mp4} type="video/mp4"/>
        <source src={webp} type="video/webp"/>
      </video>
    </div>
