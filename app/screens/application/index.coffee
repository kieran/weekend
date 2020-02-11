import React from 'react'

import parse            from 'date-fns/parseISO'
import format           from 'date-fns/format'
import addDays          from 'date-fns/addDays'
import isWithinInterval from 'date-fns/isWithinInterval'

import { get } from 'axios'

class Holiday
  constructor: ({@date, @name, @informal, @observed, @regions=[]})->
    @date = parse @date if 'string' is typeof @date

  isWithinInterval: (interval)->
    isWithinInterval @date, interval

  @thisWeek: (locale)->
    now = new Date
    interval = start: now, end: addDays now, 7
    { data: holidays } = await get "#{locale}.json"
    days = (new Holiday(h) for h in holidays)
    (d for d in days when d.isWithinInterval interval)

  @next: (locale)->
    holidays = await @thisWeek locale

    # get next serious holiday
    return h for h in holidays when not h.informal
    # or next informal holiday
    return h for h in holidays when h.informal
    # or nothing
    null

getLocale = ->
  { data: {country_code, region_code} } = await get "https://ipapi.co/json"
  [country_code, region_code].join('_').toLowerCase()

class Gif extends React.Component
  constructor: (props)->
    super arguments...
    @state =
      gif: null

    do =>
      @setState gif: await @getGif props.name

  getGif: (term='work sad')=>
    api_key = '02c86584244447a3884c4a867d36932b'
    q = term.replace /\s/g, '+'
    url = "https://api.giphy.com/v1/gifs/search?q=#{q}&api_key=#{api_key}&limit=10"

    { data: data: gifs } = await get url

    num = Math.floor Math.random() * gifs.length

    gif = gifs[num].images.original
    gif.poster = gifs[num].images.original_still.url

    gif.width = parseInt gif.width
    gif.height = parseInt gif.height

    gif.aspect_ratio = gif.width / gif.height

    gif

  render: ->
    return null unless gif = @state.gif
    <div className="fullscreen-bg">
      <video loop='true' muted='true' autoPlay='true' poster={gif.poster} className="fullscreen-bg__video">
        <source src={gif.mp4} type="video/mp4"/>
        <source src={gif.webp} type="video/webp"/>
      </video>
    </div>

# import container from './container'
export default \
class Application extends React.Component
  constructor: (props)->
    super arguments...
    @state =
      loaded: false
      holiday: null
    do =>
      locale = await getLocale()
      holiday = await Holiday.next  locale
      @setState { holiday, loaded: true }

  render: ->
    return @loading 'Ummmmm...' unless @state.loaded
    if @state.holiday then @yes() else @no()

  loading: (text)->
    <div className="container">
      <h1>{text}</h1>
    </div>

  no: ->
    <div className="container">
      <h1>NO</h1>
      <Gif name={'work sad'}/>
    </div>

  yes: ->
    {informal, name} = @state.holiday
    <div className="container">
      {if informal
        <h1>Maybe <code>¯\_(ツ)_/¯</code></h1>
      else
        <h1>Yes</h1>
      }
      {@holidayDescription()}
      <Gif name={name}/>
    </div>

  holidayDescription: ->
    weekday = format @state.holiday.date, 'EEEE'
    name = @state.holiday.name
    <h2>
      {"This #{weekday} is #{name}"}
      {if @state.holiday.observed
        {' (observed)'}
      }
    </h2>
