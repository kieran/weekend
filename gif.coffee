import React from 'react'
import fixWeirdGusses from '/fix-weird-guesses'

url     = 'https://api.giphy.com/v1/gifs/search'
api_key = '02c86584244447a3884c4a867d36932b'
limit   = 20

sample = (arr=[])->
  arr[Math.floor Math.random() * arr.length]

export default \
class Gif extends React.Component
  constructor: ->
    super arguments...
    @state = {}

  componentDidMount: =>
    # giphy setup
    correctedName = fixWeirdGusses[@props.name] or @props.name
    q = (correctedName or 'work sad').replace(/\s+/g, '+')

    # get gifs
    res = await fetch "#{url}?#{new URLSearchParams {api_key, limit, q}}"
    { data: gifs } = await res.json()

    # fetch a random result
    gif = sample gifs

    {
      original: { mp4, webp }
      original_still: { url: poster }
    } = gif.images

    @setState { mp4, webp, poster }

  render: ->
    { mp4, webp, poster } = @state
    return null unless poster
    <div className="Gif">
      <video loop={true} muted={true} playsInline={true} autoPlay={true} poster={poster}>
        <source src={mp4} type="video/mp4"/>
        <source src={webp} type="video/webp"/>
      </video>
    </div>
