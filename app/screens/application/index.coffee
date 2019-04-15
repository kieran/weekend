import React from 'react'

import format from 'date-fns/format'
import parse  from 'date-fns/parse'

import container from './container'
export default container class Application extends React.Component
  constructor: (props)->
    super arguments...
    props.getLocation()

  gif: (name)->
    return null if @props.gifLoading
    unless gif = @props.gif
      @props.getGif name
      return null

    <div className="fullscreen-bg">
      <video loop='true' muted='true' autoPlay='true' poster={gif.poster} className="fullscreen-bg__video">
        <source src={gif.mp4} type="video/mp4"/>
        <source src={gif.webp} type="video/webp"/>
      </video>
    </div>

  yes: ->
    informal = !! @props.primaryHoliday.informal
    name = @props.primaryHoliday.name
    <div className="container">
      {if informal
        <h1>Maybe <code>¯\_(ツ)_/¯</code></h1>
      else
        <h1>Yes</h1>
      }
      {@holidayDescription()}
      {@gif name}
    </div>

  no: ->
    <div className="container">
      <h1>NO</h1>
      {@gif 'work sad'}
    </div>

  loading: (text)->
    <div className="container">
      <h1>{text}</h1>
    </div>

  render: ->
    return @loading 'Ummmmm...' if @props.locationLoading
    return @loading 'Uhhhhh...' unless @props.holidays?.length
    return @loading 'Uhhhhh...' if @props.holidaysLoading
    return @yes() if @props.primaryHoliday
    @no()

  holidayDescription: ->
    weekday = format parse(@props.primaryHoliday.date), 'dddd'
    name = @props.primaryHoliday.name
    <h2>
      {"This #{weekday} is #{name}"}
      {if @props.primaryHoliday.observed
        {' (observed)'}
      }
    </h2>
