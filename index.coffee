import React      from 'react'
import { render } from 'react-dom'
import Gif        from '/gif'

import './styles.sass'

import format           from 'date-fns/format'
import parse            from 'date-fns/parseISO'
import addDays          from 'date-fns/addDays'
import isWithinInterval from 'date-fns/isWithinInterval'

holidaysHere = ->
  res = await fetch "/holidays"
  res.json()

holidaysThisWeek = ->
  now = new Date
  interval = start: now, end: addDays now, 7
  ret = (h for h in await holidaysHere() when isWithinInterval parse(h.observed or h.date), interval)

nextHoliday = ->
  holidays = await holidaysThisWeek()
  # get next serious holiday
  return h for h in holidays when not h.informal
  # or next informal holiday
  return h for h in holidays when h.informal
  # or nothing
  null

class Application extends React.Component
  constructor: (props)->
    super arguments...
    @state =
      loaded:   false
      holiday:  null

  componentDidMount: =>
    @setState {
      loaded:   true
      holiday:  await nextHoliday()#Holiday.next await getHolidays()
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
          <h2>
            This {format parse(date), 'EEEE'} is {name}
            {if observed and not informal
              <div>(we get {format parse(date), 'EEEE'} off)</div>
            }
            </h2>
          <Gif name={name}/>
        </>


render <Application />, document.getElementById "application"
