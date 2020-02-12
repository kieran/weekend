import React      from 'react'
import { render } from 'react-dom'

import format   from 'date-fns/format'
import { get } from 'axios'

import Holiday  from '/holiday'
import Gif      from '/gif'

import './style'

getLocale = ->
  { data: {country_code, region_code} } = await get "https://ipapi.co/json"
  [country_code, region_code].join('_').toLowerCase()

class Application extends React.Component
  constructor: (props)->
    super arguments...
    @state =
      loaded:   false
      holiday:  null

    do =>
      @setState {
        loaded:   true
        holiday:  await Holiday.next await getLocale()
      }

  render: ->
    <div className="container">{@content()}</div>

  content: ->
    switch
      when not @state.loaded
        <h1>Ummmmm.....</h1>
      when not @state.holiday
        <>
          <h1>NO</h1>
          <Gif name={'work sad'}/>
        </>
      else
        { name, date, informal, observed } = @state.holiday
        <>
          {if informal
            <h1>Maybe <code>¯\_(ツ)_/¯</code></h1>
          else
            <h1>Yes</h1>
          }
          <h2>This {format date, 'EEEE'} is {name} {'(observed)' if observed}</h2>
          <Gif name={name}/>
        </>


render <Application />, document.getElementById "application"
