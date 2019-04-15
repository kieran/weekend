import store from '/store'
import compact from 'lodash-es/compact'

import 'whatwg-fetch'

export getGif = (term='work sad')->
  api_key = '02c86584244447a3884c4a867d36932b'
  q = term.replace /\s/g, '+'
  url = "https://api.giphy.com/v1/gifs/search?q=#{q}&api_key=#{api_key}&limit=10"

  store.dispatch
    type: 'GET_GIF'

  fetch url
  .then (response)->
    response.json()
  .then (data)->
    num = Math.floor Math.random() * data.data.length

    gif = data.data[num].images.original
    gif.poster = data.data[num].images.original_still.url
    gif.width = parseInt gif.width
    gif.height = parseInt gif.height
    gif.aspect_ratio = gif.width / gif.height

    store.dispatch
      type: 'RECEIVE_GIF'
      gif:    gif
